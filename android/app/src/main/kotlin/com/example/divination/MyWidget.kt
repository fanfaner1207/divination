// 建立小工具邏輯 (AppWidgetProvider)
// 作用: 這是小工具的「大腦」，繼承自 AppWidgetProvider，負責處理小工具的生命週期事件 (如更新) 和互動 (如按鈕點擊)。
// 它透過接收系統廣播 (Broadcast) 來觸發相應的邏輯。
package com.example.divination

import android.app.PendingIntent  
import android.content.Intent 
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteQueryBuilder
import android.util.Log
import java.time.LocalDate
import java.time.format.DateTimeFormatter
import android.content.ContentValues
import java.time.temporal.ChronoUnit

class MyWidget : AppWidgetProvider()
{
    companion object {
        const val ACTION_UPDATE_COUNTER = "UPDATE_COUNTER"
        const val ACTION_BUTTON_CLICKED = "BUTTON_CLICKED"
        const val DATABASE_NAME = "writing.DB" // 資料庫名稱
        const val DATABASE_TABLE = "writing"   
        const val COLUMN_WORDCOUNT = "wordCount"       
        const val COLUMN_LASTUSEDDATE = "lastUsedDate"
        const val COLUMN_DAILYWORDINCREMENT = "dailyWordIncrement"
        
        val BUTTON_ID = R.id.widget_button // 按鈕在 widget_layout.xml 中的 ID 是 Button
    }

    /**
     * 觸發時機：當小工具第一次被新增到桌面，或到達 widget_info.xml 中 `updatePeriodMillis` 所設定的更新時間時。
     * 作用：遍歷所有需要更新的小工具實例，並呼叫 `updateAppWidget()` 來刷新它們的畫面。
     */
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // 遍歷所有同類型的小工具實例
        for (appWidgetId in appWidgetIds) {
        updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    /**
     * 核心商業邏輯函式。
     * 觸發時機：被 onUpdate() 或 onReceive() 呼叫時。
     * 作用：讀取 Flutter App 共用的 SQLite 資料庫，計算最新的字數，將新字數和日期寫回資料庫，
     *      最後更新小工具介面上的文字。
     */
    private fun reloadData(
        context: Context,
        views: RemoteViews
    ){
        var db: SQLiteDatabase? = null
        try {
            val dbFile = context.getDatabasePath(DATABASE_NAME)
            if (dbFile.exists()) {
                db = SQLiteDatabase.openDatabase(dbFile.path, null, SQLiteDatabase.OPEN_READWRITE)
                val cursor = db.query(
                    DATABASE_TABLE,
                    arrayOf(COLUMN_WORDCOUNT,COLUMN_LASTUSEDDATE,COLUMN_DAILYWORDINCREMENT),
                    null, null, null, null, null
                )
                if (cursor.moveToFirst()) {
                    val wordCountValueStr  = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_WORDCOUNT))
                    val lastUsedDateStr = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_LASTUSEDDATE))
                    val dailyWordIncrementStr = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_DAILYWORDINCREMENT))
                    
                    Log.d("MyWidget", "wordCountValueStr=$wordCountValueStr、lastUsedDateStr=$lastUsedDateStr、dailyWordIncrementStr=$dailyWordIncrementStr")
                    val formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd")
                    val lastUsedDate_LocalDate: LocalDate  = LocalDate.parse(lastUsedDateStr, formatter)

                    val current = LocalDate.now()
                    val durationInDays  =  ChronoUnit.DAYS.between(lastUsedDate_LocalDate, current)            
                    Log.d("MyWidget", "current=$current、durationInDays=$durationInDays")

                    // 計算新的 wordCountValue (注意要先將字串轉為數字再計算)
                    val currentWordCount = wordCountValueStr.toLongOrNull() ?: 0L // 將 wordCountValue 轉為 Long
                    val increment = dailyWordIncrementStr.toLongOrNull() ?: 0L // 將 wordCountValue 轉為 Long

                    val newWordCountValue=currentWordCount+(durationInDays*increment)  
                                   
                    Log.d("MyWidget", "currentWordCount=$currentWordCount,durationInDays=$durationInDays,increment=$increment")
                    Log.d("MyWidget", "newWordCountValue=$newWordCountValue")

                    // 格式化 current 時間為字串以寫入 DB
                    val currentFormatted = current.format(formatter)

                    // 更新資料庫
                    val values = ContentValues().apply {
                        put(COLUMN_WORDCOUNT, newWordCountValue)
                        put(COLUMN_LASTUSEDDATE, currentFormatted)
                    }

                    val rowsAffected = db.update(
                        DATABASE_TABLE,
                        values,
                        null, // 你可以使用 WHERE 子句來更新特定的行，例如 "id = ?"
                        null  // 如果使用了 WHERE 子句，這裡需要提供對應的值
                    )

                    if (rowsAffected > 0) {
                        Log.d("MyWidget", "資料庫更新成功：wordCount=$newWordCountValue, lastUsedDate=$currentFormatted")
                        
                        views.setTextViewText(R.id.widget_text,"目前字數：${newWordCountValue.toString()}" ) // 更新 Widget 顯示
                    } else {
                        Log.e("MyWidget", "資料庫更新失敗")
                        views.setTextViewText(R.id.widget_text, "更新失敗")
                    }
                } else {
                    views.setTextViewText(R.id.widget_text, "沒有資料")
                }
                cursor.close()
            } else {
                views.setTextViewText(R.id.widget_text, "資料庫不存在")
            }
        } catch (e: Exception) {
            e.printStackTrace()
            views.setTextViewText(R.id.widget_text, "讀取資料錯誤")
        } finally {
            db?.close()
        }
    }
    
    /**
     * 負責準備並設定小工具的 UI。
     * 作用：1. 載入 widget_layout.xml 佈局。
     *      2. 建立一個帶有 "CLICK_ACTION" 的 PendingIntent，並將其綁定到按鈕的點擊事件上。
     */
    private fun updateAppWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        widgetId: Int
    ) {
        // 加載佈局檔案
        val views = RemoteViews(context.packageName, R.layout.widget_layout)

        // 1. 建立一個 Intent，其 action 為我們自定義的 CLICK_ACTION。
        val intent = Intent(context, MyWidget::class.java).apply {
            action = ACTION_BUTTON_CLICKED
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId)
        }
        // 2. 將 Intent 包裝成 PendingIntent。PendingIntent 是一個令牌，可以授權其他應用程式 (如此處的主畫面) 在未來某個時間點代表我們的 App 執行操作。
        //    當按鈕被點擊時，主畫面 App 就會使用這個 PendingIntent 來廣播我們的 Intent。
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            widgetId, // 使用 widgetId 作為 requestCode，確保每個 Widget 實例有唯一的 PendingIntent
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        views.setOnClickPendingIntent(BUTTON_ID, pendingIntent)

        // 呼叫 reloadData 來載入初始資料
        reloadData( context,views)

        // 更新小工具
        appWidgetManager.updateAppWidget(widgetId, views)
        }   

    

    /**
     * 事件的總入口。
     * 觸發時機：任何發送給這個小工具的廣播 (Broadcast) 都會先經過這裡，包含 onUpdate 和我們自訂的按鈕點擊事件。
     * 作用：判斷收到的 Intent Action。在此專案中，它會捕捉到按鈕點擊發出的 "CLICK_ACTION"，然後觸發 `reloadData()` 來更新資料與 UI。
     */
    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)

        val appWidgetManager = AppWidgetManager.getInstance(context)
        // 取得小工具 ID（需從 Intent 中解析）
        val widgetId = intent.getIntExtra(
            AppWidgetManager.EXTRA_APPWIDGET_ID,
            AppWidgetManager.INVALID_APPWIDGET_ID
        )

                
        // 更新小工具內容
        // R是在 Android 開發中，R 是一個由系統自動產生的 資源索引類別（全名 R.java），它提供了應用程式中所有資源（如佈局、字串、圖片等）的靜態引用
        val views = RemoteViews(context.packageName, R.layout.widget_layout)

        // 在這裡處理按鈕點擊後的邏輯
        if (widgetId != AppWidgetManager.INVALID_APPWIDGET_ID) {
            Log.d("MyWidget", "按鈕被點擊了！Widget ID: $widgetId")

            // views.setTextViewText(R.id.widget_text, "按鈕被點擊了！Widget ID: $widgetId")            
            reloadData( context,views)
            appWidgetManager.updateAppWidget(widgetId, views)
        }        
      
    }
}

