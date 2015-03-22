/*
 * Сделано в SharpDevelop.
 * Пользователь: Catfish
 * Дата: 16.02.2014
 * Время: 9:45
 * 
 * Для изменения этого шаблона используйте Сервис | Настройка | Кодирование | Правка стандартных заголовков.
 */
using System;
using System.Drawing;
using System.Windows.Forms;

namespace AdminQA.Service
{
	/// <summary>
	/// Description of FormServiceCalculator.
	/// </summary>
	public partial class FormServiceCalculator : Form
	{
		private Double memory = 0;
		private String ActionEvent = "";
		private bool CalcCLEAR = true;
		//private String MeActivate = "";
		public TextBox TextBoxReturnValue;
		public bool valuePaste = true;
		
		public FormServiceCalculator(bool Paste)
		{
			//
			// The InitializeComponent() call is required for Windows Forms designer support.
			//
			InitializeComponent();
			
			//
			// TODO: Add constructor code after the InitializeComponent() call.
			//
		}
		
		void inputValue(String Value)
		{
			if(CalcCLEAR == true){
				textBox1.Text = Value;
				CalcCLEAR = false;
			} else textBox1.Text = textBox1.Text + Value;	
		}
		void Button1Click(object sender, EventArgs e)
		{
			inputValue("0");
		}
		
		void Button3Click(object sender, EventArgs e)
		{
			inputValue("1");		
		}
		
		void Button4Click(object sender, EventArgs e)
		{
			inputValue("2");			
		}
		
		void Button5Click(object sender, EventArgs e)
		{
			inputValue("3");			
		}
		
		void Button6Click(object sender, EventArgs e)
		{
			inputValue("4");			
		}
		
		void Button7Click(object sender, EventArgs e)
		{
			inputValue("5");			
		}
		
		void Button8Click(object sender, EventArgs e)
		{
			inputValue("6");			
		}
		
		void Button9Click(object sender, EventArgs e)
		{
			inputValue("7");			
		}
		
		void Button10Click(object sender, EventArgs e)
		{
			inputValue("8");			
		}
		
		void Button11Click(object sender, EventArgs e)
		{
			inputValue("9");			
		}
		
		void Button19Click(object sender, EventArgs e)
		{
			textBox1.Text = "0";
			memory = 0;
			ActionEvent = "";
			CalcCLEAR = true;
		}
		
		void Button2Click(object sender, EventArgs e)
		{
			inputValue(",");			
		}
		
		void Button12Click(object sender, EventArgs e)
		{
			ActionEvent = "Деление";
			memory = Convert.ToDouble(textBox1.Text);
			CalcCLEAR = true;			
		}
		
		void Button13Click(object sender, EventArgs e)
		{
			ActionEvent = "Умножение";
			memory = Convert.ToDouble(textBox1.Text);
			CalcCLEAR = true;
		}
		
		void Button14Click(object sender, EventArgs e)
		{
			ActionEvent = "Вычитание";
			memory = Convert.ToDouble(textBox1.Text);
			CalcCLEAR = true;			
		}
		
		void Button15Click(object sender, EventArgs e)
		{
			ActionEvent = "Сложение";
			memory = Convert.ToDouble(textBox1.Text);
			CalcCLEAR = true;			
		}
		
		void Button16Click(object sender, EventArgs e)
		{
			ActionEvent = "Проценты";
			Double Value = Convert.ToDouble(textBox1.Text);
			Double Result;
			if(ActionEvent == "Проценты"){
				Result = memory * Value / 100;
				textBox1.Text = Result.ToString();
			}
		}
		
		void Button17Click(object sender, EventArgs e)
		{
			try{
				if(ActionEvent == "Деление"){
					Double Result = memory / Convert.ToDouble(textBox1.Text);
					textBox1.Text = Result.ToString();
				}
				if(ActionEvent == "Умножение"){
					Double Result = memory * Convert.ToDouble(textBox1.Text);
					textBox1.Text = Result.ToString();
				}
				if(ActionEvent == "Вычитание"){
					Double Result = memory - Convert.ToDouble(textBox1.Text);
					textBox1.Text = Result.ToString();
				}
				if(ActionEvent == "Сложение"){
					Double Result = memory + Convert.ToDouble(textBox1.Text);
					textBox1.Text = Result.ToString();
				}
				CalcCLEAR = true;
			}catch(Exception ex){
				MessageBox.Show(ex.ToString());	//Сообщение об ошибке
			}
		}
		
		void Button18Click(object sender, EventArgs e)
		{
			if(valuePaste) TextBoxReturnValue.Text = ClassConversion.StringToMoney(textBox1.Text);
			Close();
		}
	}
}
