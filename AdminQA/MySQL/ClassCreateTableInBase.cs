/*
 * Сделано в SharpDevelop.
 * Пользователь: Catfish
 * Дата: 21.09.2013
 * Время: 9:22
 * 
 * Для изменения этого шаблона используйте Сервис | Настройка | Кодирование | Правка стандартных заголовков.
 */
using System;
using System.Windows.Forms;
using MySql.Data.MySqlClient;

namespace AdminQA
{
	/// <summary>
	/// Description of ClassCreateTableInBase.
	/// </summary>
	public class ClassCreateTableInBase
	{
		//конструктор -----------------
		public ClassCreateTableInBase()
		{
			_MySql_Connection = new MySqlConnection();
			_MySql_Command = new MySqlCommand("", _MySql_Connection);
		}
		
		//свойства ---------------------
		public String Server
		{
			get {return _server;}
			set {_server = value;}
		}
		public String DataBase
		{
			get {return _database;}
			set {_database = value;}
		}
		public String UserID
		{
			get {return _userid;}
			set {_userid = value;}
		}
		public String Pass
		{
			get {return _pass;}
			set {_pass = value;}
		}
		
		//методы --------------------------
		public bool CreateTables()
		{
			try{
				//Создание базы данных ===================================
				_MySql_Connection.ConnectionString = "server=" + _server + ";database=;uid=" + _userid + ";pwd=" + _pass + ";";
				_MySql_Connection.Open();
				_SqlCommand = "CREATE DATABASE " + _database;
				_MySql_Command.CommandText = _SqlCommand;
				_MySql_Command.ExecuteNonQuery();	//выполнение запроса
				_MySql_Connection.Close();
				
				//Создание таблиц в базе данных ===========================
				_MySql_Connection.ConnectionString = "server=" + _server + ";database=" + _database + ";uid=" + _userid + ";pwd=" + _pass + ";";
				_MySql_Connection.Open();
				
				
				/*Создание таблицы "Пользователи" (users)
				 * users_system				- идентификатор
				 * users_system_name		- имя пользователя
				 * users_system_login		- логин пользователя
				 * users_system_pass		- пароль
				 * users_system_status		- права
				 */
				_SqlCommand = "CREATE TABLE users_system (users_system_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, " +
					"users_system_name VARCHAR(250) DEFAULT '' UNIQUE, " +
					"users_system_login VARCHAR(250) DEFAULT '' UNIQUE, " +
					"users_system_pass VARCHAR(250) DEFAULT '', " +
					"users_system_status INT(1) DEFAULT 0)";
				_MySql_Command.CommandText = _SqlCommand;
				_MySql_Command.ExecuteNonQuery();	//выполнение запроса
				_SqlCommand = "INSERT INTO users_system (users_system_name, users_system_login, users_system_pass, users_system_status) VALUES ('Администратор', 'Администратор', 'admin', 1)";
				_MySql_Command.CommandText = _SqlCommand;
				_MySql_Command.ExecuteNonQuery();	//выполнение запроса
				_SqlCommand = "INSERT INTO users_system (users_system_name, users_system_login, users_system_pass, users_system_status) VALUES ('Пользователь', 'Пользователь', 'user', 0)";
				_MySql_Command.CommandText = _SqlCommand;
				_MySql_Command.ExecuteNonQuery();	//выполнение запроса
				
				
				_MySql_Connection.Close();
				return true;
			}catch(Exception ex){
				_MySql_Connection.Close();
				MessageBox.Show(ex.ToString());	//Сообщение об ошибке
				return false;
			}
		}
		
		//поля ---------------------------
		private MySqlConnection _MySql_Connection;
		private MySqlCommand _MySql_Command;
		private String _server;
		private String _database;
		private String _userid;
		private String _pass;
		private String _SqlCommand;
	}
}
