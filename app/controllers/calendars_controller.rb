class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def get_week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']
    
    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日
    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = []
      plan = plans.map do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end
      #①Date.today.wdayを利用して添字となる数値を得る。Date.today.wdayは今日の日付に対する曜日の添字が返ってくる。
      #何回繰り返しても今日の添字が返ってくるから何かを足してあげる。足すもののヒントはtimesメソッドを使うときに定義する｜｜のやつ
      wday_num = Date.today.wday + x
      #もしもwday_numが7以上であれば、7を引く
      if wday_num >= 7 #②条件式を記述　条件式はもしも「wday_numが7以上であれば」を書く。
        wday_num = wday_num - 7
      end
      days = { month: (@todays_date + x).month, date: (@todays_date+x).day, plans: today_plans, wday: wdays[wday_num]}#③wday_numが配列の呼び出す添字になることに注意して、wdaysから添字を使って曜日の文字列を取り出す。

      @week_days.push(days)
    end

  end
end
