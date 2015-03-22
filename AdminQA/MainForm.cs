/*
 * Сделано в SharpDevelop.
 * Пользователь: Catfish
 * Дата: 21.03.2015
 * Время: 12:57
 * 
 * Для изменения этого шаблона используйте Сервис | Настройка | Кодирование | Правка стандартных заголовков.
 */
using System;
using System.IO;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;
using AdminQA.Forms;

namespace AdminQA
{
	/// <summary>
	/// Description of MainForm.
	/// </summary>
	public partial class MainForm : Form
	{
		public MainForm()
		{
			//
			// The InitializeComponent() call is required for Windows Forms designer support.
			//
			InitializeComponent();
			
			//
			// TODO: Add constructor code after the InitializeComponent() call.
			//
		}
		
		void MainFormLoad(object sender, EventArgs e)
		{
			timer1.Start();	//запуск таймера
		}
		
		void Timer1Tick(object sender, EventArgs e)
		{
			timer1.Stop();	//остановка таймера
			//определяем расположение программы (путь)
			Config.programPath = Environment.CurrentDirectory + "\\";
			//расположение папки ресурсов
			Config.folderResource  = Config.programPath + "config";
			//Проверка существования папки
			if(!Directory.Exists(Config.folderResource))
			{
				//папки нет, она будет создана заново
				Directory.CreateDirectory(Config.folderResource);
			}
			
			/* Файл конфигурации */
			Config.fileConfig = Config.folderResource + "\\config.cfg";
			if(!File.Exists(Config.fileConfig))
			{
				//файл не найден, он будет создан
				CreateConfig cConfig = new CreateConfig(this);
				cConfig.ShowDialog();
			}else{
				ShowAdmin();
			}
			
		}
		
		public void ShowAdmin()
		{
			Visible = false;	//главная форма становится невидимой
			Administrator admin = new Administrator();
			admin.Show();
		}
		
	}
}
