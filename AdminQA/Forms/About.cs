/*
 * Сделано в SharpDevelop.
 * Пользователь: Catfish
 * Дата: 22.03.2015
 * Время: 11:04
 * 
 * Для изменения этого шаблона используйте Сервис | Настройка | Кодирование | Правка стандартных заголовков.
 */
using System;
using System.Drawing;
using System.Windows.Forms;

namespace AdminQA.Forms
{
	/// <summary>
	/// Description of About.
	/// </summary>
	public partial class About : Form
	{
		public About()
		{
			//
			// The InitializeComponent() call is required for Windows Forms designer support.
			//
			InitializeComponent();
			
			//
			// TODO: Add constructor code after the InitializeComponent() call.
			//
		}
		
		void AboutLoad(object sender, EventArgs e)
		{
			Classes.ClassForms.formAbout = true;			
		}
		
		void AboutClosed(object sender, EventArgs e)
		{
			Classes.ClassForms.formAbout = false;			
		}
		
	}
}
