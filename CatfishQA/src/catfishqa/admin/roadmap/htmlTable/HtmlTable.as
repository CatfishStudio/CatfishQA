package catfishqa.admin.roadmap.htmlTable 
{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.html.HTMLLoader;
	import flash.net.URLRequest;
	
	public class HtmlTable extends Sprite 
	{
		private var _htmlLoader:HTMLLoader;
		
		public function HtmlTable() 
		{
			super();
			name = "htmlTable";
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_htmlLoader = new HTMLLoader();
			_htmlLoader.width = stage.stageWidth;
			_htmlLoader.height = stage.stageHeight;
			_htmlLoader.loadString("<html><body><h1>...</h1></body></html>");
			addChild(_htmlLoader);
		}
		
		private function onRemoveStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveStage);
			
		}
		
		public function setSize(_width:Number, _height:Number):void
		{
			
			if (_width < 730 || _height < 260)
			{
				_htmlLoader.width = 730;
				_htmlLoader.height = 260;
			}else{
				_htmlLoader.width = _width;
				_htmlLoader.height = _height;
			}
		}
		
		public function setData(data:Array):void
		{
			var tableMainWidth:int = _htmlLoader.width - 30;
			var divDivheadWidth:int = _htmlLoader.width - 230;
			var divHorizontalScrollWidth:int = _htmlLoader.width - 27;
			
			var tableMainHeight:int = _htmlLoader.height - 60;
			var divFrozenHeight:int = _htmlLoader.height - 60; 			// height: 200px
			var divContentHeight:int = _htmlLoader.height - 60 ;		// height: 200px 
			var divVerticalScrollHeight:int = _htmlLoader.height - 33;	// height: 227px
			var divVerticalScrollDiv:int = 50 * data.length;			// height: 337px
			
			
			var dateTable:Array = [];
			dateTable = buildingDateTable(data);
			var dataTable:Array = [];
			
			var n:int = data.length;
			var page:String;
			page = "<html xmlns=\"http://www.w3.org/1999/xhtml\">"
			+"<head id=\"Head1\" runat=\"server\">"
			+"<title></title>"
			+"<style type=\"text/css\">"
			//+"table.main {width: " + tableMainWidth.toString() + "px; height: 221px; table-layout: fixed;}"
			+"table.main {width: " + tableMainWidth.toString() + "px; height: " + tableMainHeight.toString() + "px; table-layout: fixed;}"
			+"table.root {table-layout: fixed;}"
			+"table.content {table-layout: fixed; width: 1890px; }"
			+"table.head {table-layout: fixed; width: 100%;}" // изменения
			+"table.frozen {table-layout: fixed;}"
			+"td {line-height: 15px;}"
			+"div.horizontal-scroll {width: " + divHorizontalScrollWidth.toString() + "px; height: 22px; overflow: hidden; overflow-x: scroll; border: solid 1px #666;}"
			+"div.horizontal-scroll div {width: 5000px; height: 1px;}" // изменения
			+"div.vertical-scroll {height: " + divVerticalScrollHeight.toString() + "px; width: 22px; overflow: hidden; overflow-y: scroll; border: solid 1px #666;}"
			+"div.vertical-scroll div {height: " + divVerticalScrollDiv.toString() + "px; width: 1px;}"
			+"td.inner {border-left: 1px solid #666; border-bottom: 1px solid #666; padding: 3px; height: 28px;}"
			+"td.frozencol {border-right: 1px double #666; width: 200px;}"
			+"td.col1 {/*border-left: none;*/ width: 50px;}" // изменения
			+"td.bottomcol {}"
			+".col2, .col3, .col4, .col5, .col6, .col7, .col8, .col9, .col10 {width: 200px; overflow: hidden; text-overflow: ellipses; white-space: nowrap;}"
			+"td.head{background-color: #efefef; border-top: 1px solid #666;}"
			+".rightcol {border-right: 1px solid #666;}"
			+".toprow {border-top: 0px;}"
			+"div.root {margin-left: 0px; overflow: hidden; width: 200px; height: 28px; border-bottom: 1px solid #666;}"
			+"div.frozen {overflow: hidden; width: 200px; height: " + divFrozenHeight.toString() + "px;}"
			+"div.divhead {overflow: hidden; height: 28px; width: " + divDivheadWidth.toString() + "px; border-left: 1px solid #666; border-right: 1px solid #666; border-bottom: 1px solid #666;}"
			+"div.content {overflow: hidden; height: " + divContentHeight.toString() + "px; border-left: 1px solid #666; border-right: 1px solid #666;}"
			+"td.tablefrozencolumn {width: 200px; border-right: 3px solid #666;}"
			+"td.tablecontent {}"
			+"td.tableverticalscroll {width: 0px;}"
			+"div.ff-fill {height: 23px; width: 23px; background-color: #ccc; border-right: 1px solid #666; border-bottom: 1px solid #666;}"
			+"</style>"
			+"</head>"
			+"<body>"
			+"<form id=\"form1\" runat=\"server\">"
			+"<div>"
			+"	<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class='main'>"
			+"		<tr>"
			+"			<td class='tablefrozencolumn'>"
			+"				<div id='divroot' class='root'>"
			+"					<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" class='root'>"
			+"						<tr>"
			+"							<td class='inner frozencol colwidth head'>"
			+"Задачи:"
			+"							</td>"
			+"						</tr>"
			+"					</table>"
			+"				</div>"
			+"				<div id='divfrozen' class='frozen'>"
            +"                <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" class='frozen'>";
			
			for (var i:int = 0; i < n; i++)
			{
				if (i == 0)
				{
					page += ""
					+"                <tr>"
					+"                    <td class='inner frozencol toprow'>"
					+"						<p style=\"font-size: 10pt; height: 20px; width:200px; overflow: hidden;\">" + data[i].Задача + "</p>"
					+"                    </td>"
					+"                </tr>";
				}else {
					if (i == (n - 1))
					{
						page += ""
						+"                <tr>"
						+"                    <td class='inner frozencol bottomcol rightcol'>"
						+"						<p style=\"font-size: 10pt; height: 20px; width:200px; overflow: hidden;\">" + data[i].Задача + "</p>"
						+"                    </td>"
						+"                </tr>";
					}else {
						page += ""
						+"                <tr>"
						+"                    <td class='inner frozencol'>"
						+"						<p style=\"font-size: 10pt; height: 20px; width:200px; overflow: hidden;\">" + data[i].Задача + "</p>"
						+"                    </td>"
						+"                </tr>";
					}
				}
			}
						
			page += ""
            +"            </table>"
			+"				</div>"
			+"			</td>"
			+"			<td class='tablecontent'>"
			+"				<div id='headscroll' class='divhead'>"
			+"				<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class='head'>"
			+"					<tr>";
			
			/* ШАПКА - ДАТЫ */
			n = dateTable.length;
			for (var j:int = 0; j < n; j++)
			{
					page += ""
					+"                    <td class='inner col1 head'>"
					+"<small>" + dateTable[j] + "</small>"
					+"                    </td>";
			}
			
			page += ""
			+"					</tr>"
			+"				</table>"
			+"				</div>"
			+"				<div id='contentscroll' class='content' onscroll='reposHead(this);'>"
			+"					<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class='content' id='innercontent'>";
			
			/* ЗАПОЛНЕНИЕ ТАБЛИЦЫ ДАННЫМИ */
			dataTable = buildingDataTable(data, dateTable);
			n = dataTable.length;
			for (var m:int = 0; m < n; m++)
			{
				page += ""
				+"					<tr>";
					
				var l:int = dateTable.length;
				for (var k:int = 0; k < l; k++)
				{
					if (dataTable[m][k] == "-")
					{
						page += ""
						+"                    <td class='inner col1 toprow' style='background:#FFFFFF;'>"
						+"<small>" + dataTable[m][k] + "</small>"
						+"                    </td>";
					}
					if (dataTable[m][k] == "DV")
					{
						page += ""
						+"                    <td class='inner col1 toprow' style='background:#98F185;'>"
						+"<small>" + dataTable[m][k] + "</small>"
						+"                    </td>";
					}
					if (dataTable[m][k] == "QA")
					{
						page += ""
						+"                    <td class='inner col1 toprow' style='background:#97D2FB;'>"
						+"<small>" + dataTable[m][k] + "</small>"
						+"                    </td>";
					}
					if (dataTable[m][k] == "R")
					{
						page += ""
						+"                    <td class='inner col1 toprow' style='background:#FEA0A0;'>"
						+"<small>" + dataTable[m][k] + "</small>"
						+"                    </td>";
					}
				}
				
				page += ""
				+"					</tr>";
			}
			
			
			page += ""
			+"					</table>"
			+"				</div>"
			+"			</td>"
			+"			<td class='tableverticalscroll' rowspan=\"2\">"
			+"				<div class='vertical-scroll' onscroll='reposVertical(this);'>"
			+"					<div></div>"
			+"				</div>"
			+"				<div class='ff-fill'>"
			+"				</div>"
			+"			</td>"
			+"		</tr>"
			+"		<tr>"
			+"			<td colspan=\"3\">"
			+"				<div class='horizontal-scroll' onscroll='reposHorizontal(this);'>"
			+"					<div></div>"
			+"				</div>"
			+"			</td>"
			+"		</tr>"
			+"	</table>"
			+"</div>"
			+""
			+"<script language='javascript' type='text/javascript'>"
			+"function reposHead(e) {var h = document.getElementById('headscroll'); h.scrollLeft = e.scrollLeft; var f = document.getElementById('divfrozen'); f.scrollTop = e.scrollTop;}"
			+"function reposHorizontal(e) {var h = document.getElementById('headscroll'); var c = document.getElementById('contentscroll'); h.scrollLeft = e.scrollLeft; c.scrollLeft = e.scrollLeft; var ic = document.getElementById('innercontent');}"
			+"function reposVertical(e) {var h = document.getElementById('divfrozen'); var c = document.getElementById('contentscroll'); h.scrollTop = e.scrollTop; c.scrollTop = e.scrollTop;}"
			+"</script>"
			+"</form>"
			+"</body>"
			+"</html>";
			
			_htmlLoader.loadString(page);
		}
		
		private function numberDaysInMonth(mount:String):int
		{
			if (mount == "01") return 31;
			if (mount == "02") return 28;
			if (mount == "03") return 31;
			if (mount == "04") return 30;
			if (mount == "05") return 31;
			if (mount == "06") return 30;
			if (mount == "07") return 31;
			if (mount == "08") return 31;
			if (mount == "09") return 30;
			if (mount == "10") return 31;
			if (mount == "11") return 30;
			if (mount == "12") return 31;
			return 0;
		}
		
		private function buildingDateTable(data:Array):Array
		{
			var calendarBegin:String = data[0].DEV_Begin;
			var yearBegin:String = calendarBegin.charAt(0) + calendarBegin.charAt(1) + calendarBegin.charAt(2) + calendarBegin.charAt(3);
			var mountBegin:String = calendarBegin.charAt(5) + calendarBegin.charAt(6);
			var dayBegin:String = calendarBegin.charAt(8) + calendarBegin.charAt(9);
			
			var calendarEnd:String = data[0].QA_End;
			var yearEnd:String = calendarEnd.charAt(0) + calendarEnd.charAt(1) + calendarEnd.charAt(2) + calendarEnd.charAt(3);
			var mountEnd:String = calendarEnd.charAt(5) + calendarEnd.charAt(6);
			var dayEnd:String = calendarEnd.charAt(8) + calendarEnd.charAt(9);
			
			var dataTable:Array = [];
			
			/* Построение дней месяца */
			var countDays:int;
			if (mountBegin == mountEnd)
			{
				countDays = numberDaysInMonth(mountEnd) + 1;
				for (var i:int = 1; i < countDays; i++)
				{
					if (i < 10) dataTable.push("0" + i.toString() + "." + mountEnd);
					else dataTable.push(i.toString() + "." + mountEnd);
				}
			} else {
				countDays = numberDaysInMonth(mountBegin) + 1;
				for (var m1:int = 1; m1 < countDays; m1++)
				{
					if (m1 < 10) dataTable.push("0" + m1.toString() + "." + mountBegin);
					else dataTable.push(m1.toString() + "." + mountBegin);
				}
				countDays = numberDaysInMonth(mountEnd) + 1;
				for (var m2:int = 1; m2 < countDays; m2++)
				{
					if (m2 < 10) dataTable.push("0" + m2.toString() + "." + mountEnd);
					else dataTable.push(m2.toString() + "." + mountEnd);
				}
			}
			/* ---------------------- */
			
			return dataTable;
		}
		
		private function buildingDataTable(data:Array, date:Array):Array
		{
			var dataTable:Array = [];
			
			var calendar:String;
			var yearDevBegin:String;
			var mountDevBegin:String;
			var dayDevBegin:String;
			
			var yearDevEnd:String;
			var mountDevEnd:String;
			var dayDevEnd:String;
			
			var yearQaBegin:String;
			var mountQaBegin:String;
			var dayQaBegin:String;
			
			var yearQaEnd:String;
			var mountQaEnd:String;
			var dayQaEnd:String;
			
			var yearRelise:String;
			var mountRelise:String;
			var dayRelise:String;
			
			var countDays:int = date.length;
			
			var n:int = data.length;
			for (var i:int = 0; i < n; i++)
			{
				calendar = data[i].DEV_Begin;
				yearDevBegin = calendar.charAt(0) + calendar.charAt(1) + calendar.charAt(2) + calendar.charAt(3);
				mountDevBegin = calendar.charAt(5) + calendar.charAt(6);
				dayDevBegin = calendar.charAt(8) + calendar.charAt(9);
				
				calendar = data[i].DEV_End;
				yearDevEnd = calendar.charAt(0) + calendar.charAt(1) + calendar.charAt(2) + calendar.charAt(3);
				mountDevEnd = calendar.charAt(5) + calendar.charAt(6);
				dayDevEnd = calendar.charAt(8) + calendar.charAt(9);
			
				calendar = data[i].QA_Begin;
				yearQaBegin = calendar.charAt(0) + calendar.charAt(1) + calendar.charAt(2) + calendar.charAt(3);
				mountQaBegin = calendar.charAt(5) + calendar.charAt(6);
				dayQaBegin = calendar.charAt(8) + calendar.charAt(9);
				
				calendar = data[i].QA_End;
				yearDevEnd = calendar.charAt(0) + calendar.charAt(1) + calendar.charAt(2) + calendar.charAt(3);
				mountQaEnd = calendar.charAt(5) + calendar.charAt(6);
				dayQaEnd = calendar.charAt(8) + calendar.charAt(9);
				
				calendar = data[i].Релиз;
				yearRelise = calendar.charAt(0) + calendar.charAt(1) + calendar.charAt(2) + calendar.charAt(3);
				mountRelise = calendar.charAt(5) + calendar.charAt(6);
				dayRelise = calendar.charAt(8) + calendar.charAt(9);
			
				var dataLine:Array = [];
				var day:String = "";
				var mount:String = "";
				var year:String = "";
				
				var status:String = "";
				
				for (var j:int = 0; j < countDays; j++)
				{
					if (date[j] == (dayDevBegin + "." + mountDevBegin)) status = "DEV_BEGIN";
					if (date[j] == (dayDevEnd + "." + mountDevEnd)) status = "";
					if (date[j] == (dayQaBegin + "." + mountQaBegin)) status = "QA_BEGIN";
					if (date[j] == (dayQaEnd + "." + mountQaEnd)) status = "";
					if (date[j] == (dayRelise + "." + mountRelise)) status = "RELISE";
					
					if (status == "") dataLine.push("-");
					if (status == "DEV_BEGIN") dataLine.push("DV");
					if (status == "QA_BEGIN") dataLine.push("QA");
					if (status == "RELISE")
					{
						dataLine.push("R");
						status = "";
					}
				}
				dataTable.push(dataLine);
			}
			return dataTable;
		}
	}

}