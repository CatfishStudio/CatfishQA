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
using System.Data;
using System.Data.OleDb;
using MySql.Data.MySqlClient;

namespace AdminQA
{
	/// <summary>
	/// Description of ClassMySQL_Full.
	/// </summary>
	public class ClassMySQL_Full
	{
		//конструктор ---------------------
		public ClassMySQL_Full()
		{
			_MySql_Connection = new MySqlConnection();
			_MySql_Connection.ConnectionString = "server=" + 
				Config.Server + ";database=" + 
				Config.DataBase + ";uid=" + 
				Config.Uid + ";pwd=" + 
				Config.Pwd + ";";
			_MySql_Select_Command = new MySqlCommand("", _MySql_Connection);
			_MySql_Update_Command = new MySqlCommand("", _MySql_Connection);
			_MySql_Insert_Command = new MySqlCommand("", _MySql_Connection);
			_MySql_Delete_Command = new MySqlCommand("", _MySql_Connection);
			_MySql_DataAdapter = new MySqlDataAdapter();
		}
		
		//свойства ------------------------
		public String SelectSqlCommand
		{
			get {return _Select_SqlCommand;}
			set {_Select_SqlCommand = value;}
		}
		public String UpdateSqlCommand
		{
			get {return _Update_SqlCommand;}
			set {_Update_SqlCommand = value;}
		}
		public String InsertSqlCommand
		{
			get {return _Insert_SqlCommand;}
			set {_Insert_SqlCommand = value;}
		}
		public String DeleteSqlCommand
		{
			get {return _Delete_SqlCommand;}
			set {_Delete_SqlCommand = value;}
		}
			
		//методы --------------------------
		public bool ExecuteFill(DataSet _DataSet, String _TableName){
			try{
				_MySql_Connection.Open();
				
				_MySql_Select_Command.CommandText = _Select_SqlCommand;
				_MySql_Update_Command.CommandText = _Update_SqlCommand;
				_MySql_Insert_Command.CommandText = _Insert_SqlCommand;
				_MySql_Delete_Command.CommandText = _Delete_SqlCommand;
				_MySql_DataAdapter.SelectCommand = _MySql_Select_Command;
				_MySql_DataAdapter.UpdateCommand = _MySql_Update_Command;
				_MySql_DataAdapter.InsertCommand = _MySql_Insert_Command;
				_MySql_DataAdapter.DeleteCommand = _MySql_Delete_Command;
				_MySql_DataAdapter.Fill(_DataSet, _TableName);
				
				_MySql_Connection.Close();
				return true;
			}catch(Exception ex){
				_MySql_Connection.Close();
				return false; //произошла ошибка.
				/*if(MessageBox.Show("Ошибка выполнения SQL запроса." + System.Environment.NewLine + "Показать полное сообщение?","Ошибка:", MessageBoxButtons.YesNo) == DialogResult.Yes)	//Сообщение об ошибке
				{
					MessageBox.Show(ex.ToString());
				}
				*/
			}
		}
		
		public bool ExecuteUpdate(DataSet _DataSet, String _TableName){
			try{
				_MySql_Connection.Open();
				
				_MySql_Select_Command.CommandText = _Select_SqlCommand;
				_MySql_Update_Command.CommandText = _Update_SqlCommand;
				_MySql_Insert_Command.CommandText = _Insert_SqlCommand;
				_MySql_Delete_Command.CommandText = _Delete_SqlCommand;
				_MySql_DataAdapter.SelectCommand = _MySql_Select_Command;
				_MySql_DataAdapter.UpdateCommand = _MySql_Update_Command;
				_MySql_DataAdapter.InsertCommand = _MySql_Insert_Command;
				_MySql_DataAdapter.DeleteCommand = _MySql_Delete_Command;
				_MySql_DataAdapter.Update(_DataSet, _TableName);
				
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
		
		public void SelectParametersAdd(String parameterName, MySqlDbType dbType, int size, String sourceColumn, UpdateRowSource urs)
		{
			_MySql_Select_Command.Parameters.Add(parameterName, dbType, size, sourceColumn);
			//_MySql_Select_Command.UpdatedRowSource = urs;
		}
		
		public void InsertParametersAdd(String parameterName, MySqlDbType dbType, int size, String sourceColumn, UpdateRowSource urs)
		{
			_MySql_Insert_Command.Parameters.Add(parameterName, dbType, size, sourceColumn);
			//_MySql_Insert_Command.UpdatedRowSource = urs;
		}
		
		public void UpdateParametersAdd(String parameterName, MySqlDbType dbType, int size, String sourceColumn, UpdateRowSource urs)
		{
			_MySql_Update_Command.Parameters.Add(parameterName, dbType, size, sourceColumn);
			//_MySql_Update_Command.UpdatedRowSource = urs;			
		}
		
		public void DeleteParametersAdd(String parameterName, MySqlDbType dbType, int size, String sourceColumn, UpdateRowSource urs)
		{
			_MySql_Delete_Command.Parameters.Add(parameterName, dbType, size, sourceColumn);
			//_MySql_Delete_Command.UpdatedRowSource = urs;
		}
		
		
		//поля ----------------------------
		private MySqlConnection _MySql_Connection;
		private MySqlCommand _MySql_Select_Command;
		private MySqlCommand _MySql_Update_Command;
		private MySqlCommand _MySql_Insert_Command;
		private MySqlCommand _MySql_Delete_Command;
		private MySqlDataAdapter _MySql_DataAdapter;
		private String _Select_SqlCommand;
		private String _Update_SqlCommand;
		private String _Insert_SqlCommand;
		private String _Delete_SqlCommand;
	}
}
