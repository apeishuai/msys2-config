using Eplan.EplApi.Graphics;

public class MyScript
{
    public void Execute()
    {
        // 创建一个新的矩形
        var rectangle = new Rectangle(0, 0, 100, 100);

        // 将矩形添加到当前绘图页面
        var page = new PageHelper().GetCurrentPage();
        page.PlaceGraphic(rectangle);
    }
}