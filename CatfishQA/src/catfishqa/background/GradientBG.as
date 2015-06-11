package catfishqa.background 
{
	import flash.display.Shape;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	
	public class GradientBG extends Shape 
	{
		public var w:Number;
		public var h:Number;
		
		public function GradientBG(_width:Number, _height:Number) 
		{
			super();
			w = _width;
			h = _height;
			
			Show();
		}
		
		public function Show():void
		{
			//Устанавливаем тип градиентной заливки
			var type:String = GradientType.LINEAR;
		
			//Разворачиваем градиент под нужным нам углом (в радианах)
			//В данном случае он будет развернут на 90 градусов 
			//и градиентная заливка будет наложена сверху вниз
			var matrix:Matrix = new Matrix ;
			matrix.createGradientBox(200,200,1.5708);
		
			//Определяем цвета градиента
			var colors:Array = [0x0080FF,0x000080];
		
			//Определяем прозрачность для каждого цвета градиента
			var alphas:Array = [1,1];
		
			//Устанавливаем соотношение цветов в градиенте
			var ratios:Array = [0,255];
		
			//Начинаем градиентную заливку
			this.graphics.beginGradientFill(type, colors, alphas, ratios, matrix);
		
			//Определяем линию
			this.graphics.lineStyle(1,0x000080,1);
		
			//Рисуем квадрат, который будет залит градиентом;
			this.graphics.drawRect(0, 0, w, h);
		
			//Заканчиваем заливку;
			this.graphics.endFill();
			
		}
		
		public function Update():void
		{
			this.graphics.clear();
			var type:String = GradientType.LINEAR;
			var matrix:Matrix = new Matrix ;
			matrix.createGradientBox(200,200,1.5708);
		
			var colors:Array = [0x0080FF,0x000080];
		
			var alphas:Array = [1,1];
		
			var ratios:Array = [0,255];
		
			this.graphics.beginGradientFill(type, colors, alphas, ratios, matrix);
		
			this.graphics.lineStyle(1,0x000080,1);
		
			this.graphics.drawRect(0, 0, w, h);
		
			this.graphics.endFill();
		}
		
	}

}