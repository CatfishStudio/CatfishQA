/*
 * Сделано в SharpDevelop.
 * Пользователь: Catfish
 * Дата: 22.03.2015
 * Время: 11:23
 * 
 * Для изменения этого шаблона используйте Сервис | Настройка | Кодирование | Правка стандартных заголовков.
 */
using System;
using System.Data;
using System.Drawing;
using System.Windows.Forms;

namespace AdminQA.Forms
{
	/// <summary>
	/// Description of Authorization.
	/// </summary>
	public partial class Authorization : Form
	{
		ClassMySQL_Full _usersMySQL = new ClassMySQL_Full();
		DataSet _usersDataSet = new DataSet();
		
		public Authorization()
		{
			//
			// The InitializeComponent() call is required for Windows Forms designer support.
			//
			InitializeComponent();
			
			//
			// TODO: Add constructor code after the InitializeComponent() call.
			//
		}
		
		void AuthorizationLoad(object sender, EventArgs e)
		{
			_usersDataSet.Clear();
			_usersDataSet.DataSetName = "users_system";
			_usersMySQL.SelectSqlCommand = "SELECT * FROM users_system";
			_usersMySQL.ExecuteFill(_usersDataSet, "users_system");

			DataTable table = _usersDataSet.Tables["users_system"];
			comboBox1.Items.Clear();
			foreach(DataRow row in table.Rows)
        	{
				comboBox1.Items.Add(row["users_system_login"].ToString());
			}
		}
		
		
		void Button2Click(object sender, EventArgs e)
		{
			Close();
		}
		
		void Button1Click(object sender, EventArgs e)
		{
			if(comboBox1.SelectedIndex >=0)
			{
			
				if(_usersDataSet.Tables["users_system"].Rows[comboBox1.SelectedIndex]["users_system_login"].ToString() == comboBox1.Text)
				{
					if(_usersDataSet.Tables["users_system"].Rows[comboBox1.SelectedIndex]["users_system_pass"].ToString() == textBox1.Text)
					{
						if(_usersDataSet.Tables["users_system"].Rows[comboBox1.SelectedIndex]["users_system_status"].ToString() == "1")
						{
							Close();
						}else{
							MessageBox.Show("Вы не являетесь администратором системы.", "Сообщение");
						}
					}else{
						MessageBox.Show("Не верно указан пароль.", "Сообщение");
					}
				}else{
					MessageBox.Show("Такой логин не зарегистрирован.", "Сообщение");
				}
			}else{
				MessageBox.Show("Такой логин не зарегистрирован.", "Сообщение");
			}
		}
	}
}
