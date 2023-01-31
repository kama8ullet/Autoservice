
namespace КурсоваяБД
{
    partial class Mechanik_edit_form
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.Windows.Forms.Label номерLabel;
            System.Windows.Forms.Label wINномерLabel;
            System.Windows.Forms.Label состояниеЗаказаLabel;
            System.Windows.Forms.Label стоимостьLabel;
            System.Windows.Forms.Label датаОформленияLabel;
            System.Windows.Forms.Label датаОкончанияLabel;
            System.Windows.Forms.Label механикLabel;
            this.номерTextBox = new System.Windows.Forms.TextBox();
            this.mechanic_list_of_ordersBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.autoserviceDataSet = new КурсоваяБД.AutoserviceDataSet();
            this.wINномерTextBox = new System.Windows.Forms.TextBox();
            this.стоимостьTextBox = new System.Windows.Forms.TextBox();
            this.датаОформленияDateTimePicker = new System.Windows.Forms.DateTimePicker();
            this.датаОкончанияDateTimePicker = new System.Windows.Forms.DateTimePicker();
            this.close = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.ConfirmEditButton = new System.Windows.Forms.Button();
            this.механикTextBox = new System.Windows.Forms.TextBox();
            this.panel1 = new System.Windows.Forms.Panel();
            this.label2 = new System.Windows.Forms.Label();
            this.panel2 = new System.Windows.Forms.Panel();
            this.СостояниеЗаказаBox1 = new System.Windows.Forms.ComboBox();
            this.list_of_detaliDataGridView = new System.Windows.Forms.DataGridView();
            this.затраченнаяДетальDataGridViewTextBoxColumn1 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.производительDataGridViewTextBoxColumn1 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.серийныйНомерDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.количествоDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.стоимостьDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.list_of_detaliBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.list_of_serviceDataGridView = new System.Windows.Forms.DataGridView();
            this.dataGridViewTextBoxColumn2 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dataGridViewTextBoxColumn3 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.list_of_serviceBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.dataGridViewTextBoxColumn4 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.mechanic_list_of_ordersTableAdapter = new КурсоваяБД.AutoserviceDataSetTableAdapters.Mechanic_list_of_ordersTableAdapter();
            this.tableAdapterManager = new КурсоваяБД.AutoserviceDataSetTableAdapters.TableAdapterManager();
            this.list_of_serviceTableAdapter = new КурсоваяБД.AutoserviceDataSetTableAdapters.list_of_serviceTableAdapter();
            this.list_of_detaliTableAdapter = new КурсоваяБД.AutoserviceDataSetTableAdapters.list_of_detaliTableAdapter();
            this.затраченнаяДетальDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.производительDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            номерLabel = new System.Windows.Forms.Label();
            wINномерLabel = new System.Windows.Forms.Label();
            состояниеЗаказаLabel = new System.Windows.Forms.Label();
            стоимостьLabel = new System.Windows.Forms.Label();
            датаОформленияLabel = new System.Windows.Forms.Label();
            датаОкончанияLabel = new System.Windows.Forms.Label();
            механикLabel = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.mechanic_list_of_ordersBindingSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.autoserviceDataSet)).BeginInit();
            this.panel1.SuspendLayout();
            this.panel2.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.list_of_detaliDataGridView)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.list_of_detaliBindingSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.list_of_serviceDataGridView)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.list_of_serviceBindingSource)).BeginInit();
            this.SuspendLayout();
            // 
            // номерLabel
            // 
            номерLabel.AutoSize = true;
            номерLabel.BackColor = System.Drawing.SystemColors.ControlLight;
            номерLabel.Location = new System.Drawing.Point(25, 93);
            номерLabel.Name = "номерLabel";
            номерLabel.Size = new System.Drawing.Size(149, 17);
            номерLabel.TabIndex = 2;
            номерLabel.Text = "Номер заказ-наряда:";
            // 
            // wINномерLabel
            // 
            wINномерLabel.AutoSize = true;
            wINномерLabel.BackColor = System.Drawing.SystemColors.ControlLight;
            wINномерLabel.Location = new System.Drawing.Point(96, 158);
            wINномерLabel.Name = "wINномерLabel";
            wINномерLabel.Size = new System.Drawing.Size(79, 17);
            wINномерLabel.TabIndex = 4;
            wINномерLabel.Text = "WINномер:";
            // 
            // состояниеЗаказаLabel
            // 
            состояниеЗаказаLabel.AutoSize = true;
            состояниеЗаказаLabel.BackColor = System.Drawing.SystemColors.ControlLight;
            состояниеЗаказаLabel.Location = new System.Drawing.Point(41, 195);
            состояниеЗаказаLabel.Name = "состояниеЗаказаLabel";
            состояниеЗаказаLabel.Size = new System.Drawing.Size(134, 17);
            состояниеЗаказаLabel.TabIndex = 6;
            состояниеЗаказаLabel.Text = "Состояние Заказа:";
            // 
            // стоимостьLabel
            // 
            стоимостьLabel.AutoSize = true;
            стоимостьLabel.BackColor = System.Drawing.SystemColors.ControlLight;
            стоимостьLabel.Location = new System.Drawing.Point(93, 234);
            стоимостьLabel.Name = "стоимостьLabel";
            стоимостьLabel.Size = new System.Drawing.Size(82, 17);
            стоимостьLabel.TabIndex = 8;
            стоимостьLabel.Text = "Стоимость:";
            // 
            // датаОформленияLabel
            // 
            датаОформленияLabel.AutoSize = true;
            датаОформленияLabel.BackColor = System.Drawing.SystemColors.ControlLight;
            датаОформленияLabel.Location = new System.Drawing.Point(41, 274);
            датаОформленияLabel.Name = "датаОформленияLabel";
            датаОформленияLabel.Size = new System.Drawing.Size(137, 17);
            датаОформленияLabel.TabIndex = 10;
            датаОформленияLabel.Text = "Дата Оформления:";
            // 
            // датаОкончанияLabel
            // 
            датаОкончанияLabel.AutoSize = true;
            датаОкончанияLabel.BackColor = System.Drawing.SystemColors.ControlLight;
            датаОкончанияLabel.Location = new System.Drawing.Point(54, 308);
            датаОкончанияLabel.Name = "датаОкончанияLabel";
            датаОкончанияLabel.Size = new System.Drawing.Size(124, 17);
            датаОкончанияLabel.TabIndex = 12;
            датаОкончанияLabel.Text = "Дата Окончания:";
            // 
            // механикLabel
            // 
            механикLabel.AutoSize = true;
            механикLabel.BackColor = System.Drawing.SystemColors.ControlLight;
            механикLabel.Location = new System.Drawing.Point(106, 124);
            механикLabel.Name = "механикLabel";
            механикLabel.Size = new System.Drawing.Size(68, 17);
            механикLabel.TabIndex = 16;
            механикLabel.Text = "Механик:";
            // 
            // номерTextBox
            // 
            this.номерTextBox.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.mechanic_list_of_ordersBindingSource, "Номер", true));
            this.номерTextBox.Location = new System.Drawing.Point(180, 90);
            this.номерTextBox.Name = "номерTextBox";
            this.номерTextBox.ReadOnly = true;
            this.номерTextBox.Size = new System.Drawing.Size(171, 22);
            this.номерTextBox.TabIndex = 3;
            // 
            // mechanic_list_of_ordersBindingSource
            // 
            this.mechanic_list_of_ordersBindingSource.DataMember = "Mechanic_list_of_orders";
            this.mechanic_list_of_ordersBindingSource.DataSource = this.autoserviceDataSet;
            // 
            // autoserviceDataSet
            // 
            this.autoserviceDataSet.DataSetName = "AutoserviceDataSet";
            this.autoserviceDataSet.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema;
            // 
            // wINномерTextBox
            // 
            this.wINномерTextBox.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.mechanic_list_of_ordersBindingSource, "WINномер", true));
            this.wINномерTextBox.Location = new System.Drawing.Point(181, 155);
            this.wINномерTextBox.Name = "wINномерTextBox";
            this.wINномерTextBox.ReadOnly = true;
            this.wINномерTextBox.Size = new System.Drawing.Size(170, 22);
            this.wINномерTextBox.TabIndex = 5;
            // 
            // стоимостьTextBox
            // 
            this.стоимостьTextBox.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.mechanic_list_of_ordersBindingSource, "Стоимость", true));
            this.стоимостьTextBox.Location = new System.Drawing.Point(181, 231);
            this.стоимостьTextBox.Name = "стоимостьTextBox";
            this.стоимостьTextBox.ReadOnly = true;
            this.стоимостьTextBox.Size = new System.Drawing.Size(170, 22);
            this.стоимостьTextBox.TabIndex = 9;
            // 
            // датаОформленияDateTimePicker
            // 
            this.датаОформленияDateTimePicker.DataBindings.Add(new System.Windows.Forms.Binding("Value", this.mechanic_list_of_ordersBindingSource, "ДатаОформления", true));
            this.датаОформленияDateTimePicker.Location = new System.Drawing.Point(184, 270);
            this.датаОформленияDateTimePicker.Name = "датаОформленияDateTimePicker";
            this.датаОформленияDateTimePicker.Size = new System.Drawing.Size(167, 22);
            this.датаОформленияDateTimePicker.TabIndex = 11;
            // 
            // датаОкончанияDateTimePicker
            // 
            this.датаОкончанияDateTimePicker.CustomFormat = " ";
            this.датаОкончанияDateTimePicker.DataBindings.Add(new System.Windows.Forms.Binding("Value", this.mechanic_list_of_ordersBindingSource, "ДатаОкончания", true));
            this.датаОкончанияDateTimePicker.Format = System.Windows.Forms.DateTimePickerFormat.Custom;
            this.датаОкончанияDateTimePicker.Location = new System.Drawing.Point(184, 304);
            this.датаОкончанияDateTimePicker.Name = "датаОкончанияDateTimePicker";
            this.датаОкончанияDateTimePicker.Size = new System.Drawing.Size(167, 22);
            this.датаОкончанияDateTimePicker.TabIndex = 13;
            this.датаОкончанияDateTimePicker.Enter += new System.EventHandler(this.датаОкончанияDateTimePicker_Enter);
            // 
            // close
            // 
            this.close.AutoSize = true;
            this.close.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.close.Cursor = System.Windows.Forms.Cursors.Hand;
            this.close.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold);
            this.close.Location = new System.Drawing.Point(989, 2);
            this.close.Name = "close";
            this.close.Size = new System.Drawing.Size(27, 25);
            this.close.TabIndex = 14;
            this.close.Text = "X";
            this.close.TextAlign = System.Drawing.ContentAlignment.TopRight;
            this.close.Click += new System.EventHandler(this.close_Click);
            // 
            // label1
            // 
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F);
            this.label1.Location = new System.Drawing.Point(37, 351);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(20, 54);
            this.label1.TabIndex = 15;
            this.label1.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            this.label1.Visible = false;
            // 
            // ConfirmEditButton
            // 
            this.ConfirmEditButton.Cursor = System.Windows.Forms.Cursors.Hand;
            this.ConfirmEditButton.Location = new System.Drawing.Point(163, 362);
            this.ConfirmEditButton.Name = "ConfirmEditButton";
            this.ConfirmEditButton.Size = new System.Drawing.Size(99, 23);
            this.ConfirmEditButton.TabIndex = 16;
            this.ConfirmEditButton.Text = "Изменить";
            this.ConfirmEditButton.UseVisualStyleBackColor = true;
            this.ConfirmEditButton.Click += new System.EventHandler(this.ConfirmEditButton_Click);
            // 
            // механикTextBox
            // 
            this.механикTextBox.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.mechanic_list_of_ordersBindingSource, "Механик", true));
            this.механикTextBox.Location = new System.Drawing.Point(180, 121);
            this.механикTextBox.Name = "механикTextBox";
            this.механикTextBox.Size = new System.Drawing.Size(171, 22);
            this.механикTextBox.TabIndex = 17;
            // 
            // panel1
            // 
            this.panel1.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.panel1.Controls.Add(this.close);
            this.panel1.Controls.Add(this.label2);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(1018, 66);
            this.panel1.TabIndex = 18;
            // 
            // label2
            // 
            this.label2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F);
            this.label2.Location = new System.Drawing.Point(0, 0);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(1018, 66);
            this.label2.TabIndex = 1;
            this.label2.Text = "Изминение заказ-наряда";
            this.label2.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            this.label2.MouseDown += new System.Windows.Forms.MouseEventHandler(this.label2_MouseDown);
            this.label2.MouseMove += new System.Windows.Forms.MouseEventHandler(this.label2_MouseMove);
            // 
            // panel2
            // 
            this.panel2.BackColor = System.Drawing.SystemColors.ControlLight;
            this.panel2.Controls.Add(this.СостояниеЗаказаBox1);
            this.panel2.Controls.Add(this.list_of_detaliDataGridView);
            this.panel2.Controls.Add(this.list_of_serviceDataGridView);
            this.panel2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel2.Location = new System.Drawing.Point(0, 0);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(1018, 559);
            this.panel2.TabIndex = 19;
            this.panel2.MouseDown += new System.Windows.Forms.MouseEventHandler(this.panel2_MouseDown);
            this.panel2.MouseMove += new System.Windows.Forms.MouseEventHandler(this.panel2_MouseMove);
            // 
            // СостояниеЗаказаBox1
            // 
            this.СостояниеЗаказаBox1.FormattingEnabled = true;
            this.СостояниеЗаказаBox1.Items.AddRange(new object[] {
            "В процессе",
            "Завершён"});
            this.СостояниеЗаказаBox1.Location = new System.Drawing.Point(180, 192);
            this.СостояниеЗаказаBox1.Name = "СостояниеЗаказаBox1";
            this.СостояниеЗаказаBox1.Size = new System.Drawing.Size(171, 24);
            this.СостояниеЗаказаBox1.TabIndex = 2;
            this.СостояниеЗаказаBox1.SelectedIndexChanged += new System.EventHandler(this.СостояниеЗаказаBox1_SelectedIndexChanged);
            // 
            // list_of_detaliDataGridView
            // 
            this.list_of_detaliDataGridView.AllowUserToAddRows = false;
            this.list_of_detaliDataGridView.AllowUserToDeleteRows = false;
            this.list_of_detaliDataGridView.AutoGenerateColumns = false;
            this.list_of_detaliDataGridView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.list_of_detaliDataGridView.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.затраченнаяДетальDataGridViewTextBoxColumn1,
            this.производительDataGridViewTextBoxColumn1,
            this.серийныйНомерDataGridViewTextBoxColumn,
            this.количествоDataGridViewTextBoxColumn,
            this.стоимостьDataGridViewTextBoxColumn});
            this.list_of_detaliDataGridView.DataSource = this.list_of_detaliBindingSource;
            this.list_of_detaliDataGridView.Location = new System.Drawing.Point(395, 327);
            this.list_of_detaliDataGridView.Name = "list_of_detaliDataGridView";
            this.list_of_detaliDataGridView.ReadOnly = true;
            this.list_of_detaliDataGridView.RowHeadersWidth = 51;
            this.list_of_detaliDataGridView.RowTemplate.Height = 24;
            this.list_of_detaliDataGridView.Size = new System.Drawing.Size(601, 220);
            this.list_of_detaliDataGridView.TabIndex = 1;
            this.list_of_detaliDataGridView.RowsAdded += new System.Windows.Forms.DataGridViewRowsAddedEventHandler(this.list_of_detaliDataGridView_RowsAdded);
            this.list_of_detaliDataGridView.MouseDoubleClick += new System.Windows.Forms.MouseEventHandler(this.list_of_detaliDataGridView_MouseDoubleClick);
            // 
            // затраченнаяДетальDataGridViewTextBoxColumn1
            // 
            this.затраченнаяДетальDataGridViewTextBoxColumn1.DataPropertyName = "Затраченная деталь";
            this.затраченнаяДетальDataGridViewTextBoxColumn1.HeaderText = "Затраченная деталь";
            this.затраченнаяДетальDataGridViewTextBoxColumn1.MinimumWidth = 6;
            this.затраченнаяДетальDataGridViewTextBoxColumn1.Name = "затраченнаяДетальDataGridViewTextBoxColumn1";
            this.затраченнаяДетальDataGridViewTextBoxColumn1.ReadOnly = true;
            this.затраченнаяДетальDataGridViewTextBoxColumn1.Width = 125;
            // 
            // производительDataGridViewTextBoxColumn1
            // 
            this.производительDataGridViewTextBoxColumn1.DataPropertyName = "Производитель";
            this.производительDataGridViewTextBoxColumn1.HeaderText = "Производитель";
            this.производительDataGridViewTextBoxColumn1.MinimumWidth = 6;
            this.производительDataGridViewTextBoxColumn1.Name = "производительDataGridViewTextBoxColumn1";
            this.производительDataGridViewTextBoxColumn1.ReadOnly = true;
            this.производительDataGridViewTextBoxColumn1.Width = 125;
            // 
            // серийныйНомерDataGridViewTextBoxColumn
            // 
            this.серийныйНомерDataGridViewTextBoxColumn.DataPropertyName = "Серийный номер";
            this.серийныйНомерDataGridViewTextBoxColumn.HeaderText = "Серийный номер";
            this.серийныйНомерDataGridViewTextBoxColumn.MinimumWidth = 6;
            this.серийныйНомерDataGridViewTextBoxColumn.Name = "серийныйНомерDataGridViewTextBoxColumn";
            this.серийныйНомерDataGridViewTextBoxColumn.ReadOnly = true;
            this.серийныйНомерDataGridViewTextBoxColumn.Width = 125;
            // 
            // количествоDataGridViewTextBoxColumn
            // 
            this.количествоDataGridViewTextBoxColumn.DataPropertyName = "Количество";
            this.количествоDataGridViewTextBoxColumn.HeaderText = "Кол-во";
            this.количествоDataGridViewTextBoxColumn.MinimumWidth = 6;
            this.количествоDataGridViewTextBoxColumn.Name = "количествоDataGridViewTextBoxColumn";
            this.количествоDataGridViewTextBoxColumn.ReadOnly = true;
            this.количествоDataGridViewTextBoxColumn.Width = 60;
            // 
            // стоимостьDataGridViewTextBoxColumn
            // 
            this.стоимостьDataGridViewTextBoxColumn.DataPropertyName = "Стоимость";
            this.стоимостьDataGridViewTextBoxColumn.HeaderText = "Стоимость";
            this.стоимостьDataGridViewTextBoxColumn.MinimumWidth = 6;
            this.стоимостьDataGridViewTextBoxColumn.Name = "стоимостьDataGridViewTextBoxColumn";
            this.стоимостьDataGridViewTextBoxColumn.ReadOnly = true;
            this.стоимостьDataGridViewTextBoxColumn.Width = 90;
            // 
            // list_of_detaliBindingSource
            // 
            this.list_of_detaliBindingSource.DataMember = "list_of_detali";
            this.list_of_detaliBindingSource.DataSource = this.autoserviceDataSet;
            // 
            // list_of_serviceDataGridView
            // 
            this.list_of_serviceDataGridView.AllowUserToAddRows = false;
            this.list_of_serviceDataGridView.AllowUserToDeleteRows = false;
            this.list_of_serviceDataGridView.AutoGenerateColumns = false;
            this.list_of_serviceDataGridView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.list_of_serviceDataGridView.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.dataGridViewTextBoxColumn2,
            this.dataGridViewTextBoxColumn3});
            this.list_of_serviceDataGridView.DataSource = this.list_of_serviceBindingSource;
            this.list_of_serviceDataGridView.Location = new System.Drawing.Point(397, 90);
            this.list_of_serviceDataGridView.Name = "list_of_serviceDataGridView";
            this.list_of_serviceDataGridView.ReadOnly = true;
            this.list_of_serviceDataGridView.RowHeadersWidth = 51;
            this.list_of_serviceDataGridView.RowTemplate.Height = 24;
            this.list_of_serviceDataGridView.Size = new System.Drawing.Size(599, 220);
            this.list_of_serviceDataGridView.TabIndex = 0;
            this.list_of_serviceDataGridView.RowsAdded += new System.Windows.Forms.DataGridViewRowsAddedEventHandler(this.list_of_serviceDataGridView_RowsAdded);
            this.list_of_serviceDataGridView.MouseDoubleClick += new System.Windows.Forms.MouseEventHandler(this.list_of_serviceDataGridView_MouseDoubleClick);
            // 
            // dataGridViewTextBoxColumn2
            // 
            this.dataGridViewTextBoxColumn2.DataPropertyName = "Название услуги";
            this.dataGridViewTextBoxColumn2.HeaderText = "Название услуги";
            this.dataGridViewTextBoxColumn2.MinimumWidth = 6;
            this.dataGridViewTextBoxColumn2.Name = "dataGridViewTextBoxColumn2";
            this.dataGridViewTextBoxColumn2.ReadOnly = true;
            this.dataGridViewTextBoxColumn2.Width = 350;
            // 
            // dataGridViewTextBoxColumn3
            // 
            this.dataGridViewTextBoxColumn3.DataPropertyName = "Стоимость";
            this.dataGridViewTextBoxColumn3.HeaderText = "Стоимость";
            this.dataGridViewTextBoxColumn3.MinimumWidth = 6;
            this.dataGridViewTextBoxColumn3.Name = "dataGridViewTextBoxColumn3";
            this.dataGridViewTextBoxColumn3.ReadOnly = true;
            this.dataGridViewTextBoxColumn3.Width = 120;
            // 
            // list_of_serviceBindingSource
            // 
            this.list_of_serviceBindingSource.DataMember = "list_of_service";
            this.list_of_serviceBindingSource.DataSource = this.autoserviceDataSet;
            // 
            // dataGridViewTextBoxColumn4
            // 
            this.dataGridViewTextBoxColumn4.DataPropertyName = "Номер заказ-наряда";
            this.dataGridViewTextBoxColumn4.HeaderText = "Номер заказ-наряда";
            this.dataGridViewTextBoxColumn4.MinimumWidth = 6;
            this.dataGridViewTextBoxColumn4.Name = "dataGridViewTextBoxColumn4";
            this.dataGridViewTextBoxColumn4.Width = 125;
            // 
            // mechanic_list_of_ordersTableAdapter
            // 
            this.mechanic_list_of_ordersTableAdapter.ClearBeforeFill = true;
            // 
            // tableAdapterManager
            // 
            this.tableAdapterManager.BackupDataSetBeforeUpdate = false;
            this.tableAdapterManager.Connection = null;
            this.tableAdapterManager.UpdateOrder = КурсоваяБД.AutoserviceDataSetTableAdapters.TableAdapterManager.UpdateOrderOption.InsertUpdateDelete;
            this.tableAdapterManager.АналогTableAdapter = null;
            this.tableAdapterManager.ДеньTableAdapter = null;
            this.tableAdapterManager.ДетальTableAdapter = null;
            this.tableAdapterManager.ЗаказНарядTableAdapter = null;
            this.tableAdapterManager.ЗаписьTableAdapter = null;
            this.tableAdapterManager.КлиентTableAdapter = null;
            this.tableAdapterManager.РаботникTableAdapter = null;
            this.tableAdapterManager.РасходTableAdapter = null;
            this.tableAdapterManager.СменаTableAdapter = null;
            this.tableAdapterManager.ТранспортноеСредствоTableAdapter = null;
            this.tableAdapterManager.УслугаTableAdapter = null;
            this.tableAdapterManager.УслугиЗНTableAdapter = null;
            // 
            // list_of_serviceTableAdapter
            // 
            this.list_of_serviceTableAdapter.ClearBeforeFill = true;
            // 
            // list_of_detaliTableAdapter
            // 
            this.list_of_detaliTableAdapter.ClearBeforeFill = true;
            // 
            // затраченнаяДетальDataGridViewTextBoxColumn
            // 
            this.затраченнаяДетальDataGridViewTextBoxColumn.DataPropertyName = "Затраченная деталь";
            this.затраченнаяДетальDataGridViewTextBoxColumn.HeaderText = "Затраченная деталь";
            this.затраченнаяДетальDataGridViewTextBoxColumn.MinimumWidth = 6;
            this.затраченнаяДетальDataGridViewTextBoxColumn.Name = "затраченнаяДетальDataGridViewTextBoxColumn";
            this.затраченнаяДетальDataGridViewTextBoxColumn.ReadOnly = true;
            this.затраченнаяДетальDataGridViewTextBoxColumn.Width = 125;
            // 
            // производительDataGridViewTextBoxColumn
            // 
            this.производительDataGridViewTextBoxColumn.DataPropertyName = "Производитель";
            this.производительDataGridViewTextBoxColumn.HeaderText = "Производитель";
            this.производительDataGridViewTextBoxColumn.MinimumWidth = 6;
            this.производительDataGridViewTextBoxColumn.Name = "производительDataGridViewTextBoxColumn";
            this.производительDataGridViewTextBoxColumn.ReadOnly = true;
            this.производительDataGridViewTextBoxColumn.Width = 125;
            // 
            // Mechanik_edit_form
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1018, 559);
            this.Controls.Add(номерLabel);
            this.Controls.Add(механикLabel);
            this.Controls.Add(this.механикTextBox);
            this.Controls.Add(this.ConfirmEditButton);
            this.Controls.Add(датаОкончанияLabel);
            this.Controls.Add(this.датаОкончанияDateTimePicker);
            this.Controls.Add(датаОформленияLabel);
            this.Controls.Add(this.датаОформленияDateTimePicker);
            this.Controls.Add(стоимостьLabel);
            this.Controls.Add(this.стоимостьTextBox);
            this.Controls.Add(состояниеЗаказаLabel);
            this.Controls.Add(wINномерLabel);
            this.Controls.Add(this.wINномерTextBox);
            this.Controls.Add(this.номерTextBox);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.panel2);
            this.Controls.Add(this.label1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "Mechanik_edit_form";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Mechanik_edit_form";
            ((System.ComponentModel.ISupportInitialize)(this.mechanic_list_of_ordersBindingSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.autoserviceDataSet)).EndInit();
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.list_of_detaliDataGridView)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.list_of_detaliBindingSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.list_of_serviceDataGridView)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.list_of_serviceBindingSource)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        public AutoserviceDataSet autoserviceDataSet;
        private System.Windows.Forms.BindingSource mechanic_list_of_ordersBindingSource;
        private AutoserviceDataSetTableAdapters.Mechanic_list_of_ordersTableAdapter mechanic_list_of_ordersTableAdapter;
        private AutoserviceDataSetTableAdapters.TableAdapterManager tableAdapterManager;
        public System.Windows.Forms.TextBox номерTextBox;
        public System.Windows.Forms.TextBox wINномерTextBox;
        public System.Windows.Forms.TextBox стоимостьTextBox;
        public System.Windows.Forms.DateTimePicker датаОформленияDateTimePicker;
        public System.Windows.Forms.DateTimePicker датаОкончанияDateTimePicker;
        private System.Windows.Forms.Label close;
        public System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button ConfirmEditButton;
        public System.Windows.Forms.TextBox механикTextBox;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.BindingSource list_of_serviceBindingSource;
        public AutoserviceDataSetTableAdapters.list_of_serviceTableAdapter list_of_serviceTableAdapter;
        public System.Windows.Forms.DataGridView list_of_serviceDataGridView;
        private System.Windows.Forms.BindingSource list_of_detaliBindingSource;
        public AutoserviceDataSetTableAdapters.list_of_detaliTableAdapter list_of_detaliTableAdapter;
        public System.Windows.Forms.DataGridView list_of_detaliDataGridView;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn5;
        public System.Windows.Forms.ComboBox СостояниеЗаказаBox1;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn4;
        private System.Windows.Forms.DataGridViewTextBoxColumn номерЗаказнарядаDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn1;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn2;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn3;
        private System.Windows.Forms.DataGridViewTextBoxColumn затраченнаяДетальDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn производительDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn затраченнаяДетальDataGridViewTextBoxColumn1;
        private System.Windows.Forms.DataGridViewTextBoxColumn производительDataGridViewTextBoxColumn1;
        private System.Windows.Forms.DataGridViewTextBoxColumn серийныйНомерDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn количествоDataGridViewTextBoxColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn стоимостьDataGridViewTextBoxColumn;
    }
}