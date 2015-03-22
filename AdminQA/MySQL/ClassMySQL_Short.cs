/*
 * Сделано в SharpDevelop.
 * Пользователь: Catfish
 * Дата: 21.09.2013
 * Время: 9:21
 * 
 * Для изменения этого шаблона используйте Сервис | Настройка | Кодирование | Правка стандартных заголовков.
 */
using System;
using System.Windows.Forms;
using MySql.Data.MySqlClient;

namespace AdminQA
{
	/// <summary>
	/// Description of ClassMySQL_Short.
	/// </summary>
	public class ClassMySQL_Short
	{
		//конструктор ---------------------
		public ClassMySQL_Short()
		{
			_MySql_Connection = new MySqlConnection();
			_MySql_Connection.ConnectionString = "server=" + 
				Config.Server + ";database=" + 
				Config.DataBase + ";uid=" + 
				Config.Uid + ";pwd=" + 
				Config.Pwd + ";";
			_MySql_Command = new MySqlCommand("", _MySql_Connection);
		}
		
		//свойства ------------------------
		public String SqlCommand
		{
			get {return _SqlCommand;}
			set {_SqlCommand = value;}
		}
		
		//методы --------------------------
		public bool ExecuteNonQuery()
		{
			try{
				_MySql_Connection.Open();
				_MySql_Command.CommandText = _SqlCommand;
				_MySql_Command.ExecuteNonQuery();	//выполнение запроса
				_MySql_Connection.Close();
				return true;
			}catch(Exception ex){
				_MySql_Connection.Close();
				
				if(MessageBox.Show("Ошибка выполнения SQL запроса." + System.Environment.NewLine + "Показать полное сообщение?","Ошибка:", MessageBoxButtons.YesNo) == DialogResult.Yes)	//Сообщение об ошибке
				{
					MessageBox.Show(ex.ToString());
				}
				
				return false; //произошла ошибка.
			}
		}
		
		//поля ----------------------------
		private MySqlConnection _MySql_Connection;
		private MySqlCommand _MySql_Command;
		private String _SqlCommand;
	}
}
