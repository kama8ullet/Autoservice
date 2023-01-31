
namespace КурсоваяБД
{
    partial class Mechanic_add_form
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
            System.Windows.Forms.Label механикLabel;
            System.Windows.Forms.Label датаОформленияLabel;
            System.Windows.Forms.Label стоимостьLabel;
            System.Windows.Forms.Label состояниеЗаказаLabel;
            System.Windows.Forms.Label wINномерLabel;
            System.Windows.Forms.Label номерLabel;
            this.close = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.механикTextBox = new System.Windows.Forms.TextBox();
            this.датаОформленияDateTimePicker = new System.Windows.Forms.DateTimePicker();
            this.стоимостьTextBox = new System.Windows.Forms.TextBox();
            this.состояниеЗаказаTextBox = new System.Windows.Forms.TextBox();
            this.ConfirmAddButton = new System.Windows.Forms.Button();
            this.autoserviceDataSet = new КурсоваяБД.AutoserviceDataSet();
            this.tableAdapterManager = new КурсоваяБД.AutoserviceDataSetTableAdapters.TableAdapterManager();
            this.номерTextBox = new System.Windows.Forms.TextBox();
            this.panel1 = new System.Windows.Forms.Panel();
            this.label2 = new System.Windows.Forms.Label();
            this.panel2 = new System.Windows.Forms.Panel();
            this.label3 = new System.Windows.Forms.Label();
            this.FilterField = new System.Windows.Forms.TextBox();
            this.wINномерTextBox = new System.Windows.Forms.ComboBox();
            механикLabel = new System.Windows.Forms.Label();
            датаОформленияLabel = new System.Windows.Forms.Label();
            стоимостьLabel = new System.Windows.Forms.Label();
            состояниеЗаказаLabel = new System.Windows.Forms.Label();
            wINномерLabel = new System.Windows.Forms.Label();
            номерLabel = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.autoserviceDataSet)).BeginInit();
            this.panel1.SuspendLayout();
            this.panel2.SuspendLayout();
            this.SuspendLayout();
            // 
            // механикLabel
            // 
            механикLabel.AutoSize = true;
            механикLabel.Location = new System.Drawing.Point(39, 124);
            механикLabel.Name = "механикLabel";
            механикLabel.Size = new System.Drawing.Size(68, 17);
            механикLabel.TabIndex = 30;
            механикLabel.Text = "Механик:";
            // 
            // датаОформленияLabel
            // 
            датаОформленияLabel.AutoSize = true;
            датаОформленияLabel.Location = new System.Drawing.Point(36, 227);
            датаОформленияLabel.Name = "датаОформленияLabel";
            датаОформленияLabel.Size = new System.Drawing.Size(137, 17);
            датаОформленияLabel.TabIndex = 26;
            датаОформленияLabel.Text = "Дата Оформления:";
            // 
            // стоимостьLabel
            // 
            стоимостьLabel.AutoSize = true;
            стоимостьLabel.Location = new System.Drawing.Point(91, 183);
            стоимостьLabel.Name = "стоимостьLabel";
            стоимостьLabel.Size = new System.Drawing.Size(82, 17);
            стоимостьLabel.TabIndex = 24;
            стоимостьLabel.Text = "Стоимость:";
            // 
            // состояниеЗаказаLabel
            // 
            состояниеЗаказаLabel.AutoSize = true;
            состояниеЗаказаLabel.Location = new System.Drawing.Point(39, 144);
            состояниеЗаказаLabel.Name = "состояниеЗаказаLabel";
            состояниеЗаказаLabel.Size = new System.Drawing.Size(134, 17);
            состояниеЗаказаLabel.TabIndex = 22;
            состояниеЗаказаLabel.Text = "Состояние Заказа:";
            // 
            // wINномерLabel
            // 
            wINномерLabel.AutoSize = true;
            wINномерLabel.Location = new System.Drawing.Point(39, 158);
            wINномерLabel.Name = "wINномерLabel";
            wINномерLabel.Size = new System.Drawing.Size(79, 17);
            wINномерLabel.TabIndex = 20;
            wINномерLabel.Text = "WINномер:";
            // 
            // номерLabel
            // 
            номерLabel.AutoSize = true;
            номерLabel.Location = new System.Drawing.Point(39, 91);
            номерLabel.Name = "номерLabel";
            номерLabel.Size = new System.Drawing.Size(149, 17);
            номерLabel.TabIndex = 18;
            номерLabel.Text = "Номер заказ-наряда:";
            // 
            // close
            // 
            this.close.AutoSize = true;
            this.close.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.close.Cursor = System.Windows.Forms.Cursors.Hand;
            this.close.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold);
            this.close.Location = new System.Drawing.Point(443, 2);
            this.close.Name = "close";
            this.close.Size = new System.Drawing.Size(27, 25);
            this.close.TabIndex = 15;
            this.close.Text = "X";
            this.close.TextAlign = System.Drawing.ContentAlignment.TopRight;
            this.close.Click += new System.EventHandler(this.close_Click);
            // 
            // label1
            // 
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F);
            this.label1.Location = new System.Drawing.Point(52, 377);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(20, 54);
            this.label1.TabIndex = 16;
            this.label1.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            this.label1.Visible = false;
            // 
            // механикTextBox
            // 
            this.механикTextBox.Location = new System.Drawing.Point(108, 121);
            this.механикTextBox.Name = "механикTextBox";
            this.механикTextBox.ReadOnly = true;
            this.механикTextBox.Size = new System.Drawing.Size(204, 22);
            this.механикTextBox.TabIndex = 31;
            // 
            // датаОформленияDateTimePicker
            // 
            this.датаОформленияDateTimePicker.Location = new System.Drawing.Point(179, 227);
            this.датаОформленияDateTimePicker.Name = "датаОформленияDateTimePicker";
            this.датаОформленияDateTimePicker.Size = new System.Drawing.Size(200, 22);
            this.датаОформленияDateTimePicker.TabIndex = 27;
            // 
            // стоимостьTextBox
            // 
            this.стоимостьTextBox.Location = new System.Drawing.Point(177, 183);
            this.стоимостьTextBox.Name = "стоимостьTextBox";
            this.стоимостьTextBox.ReadOnly = true;
            this.стоимостьTextBox.Size = new System.Drawing.Size(100, 22);
            this.стоимостьTextBox.TabIndex = 25;
            // 
            // состояниеЗаказаTextBox
            // 
            this.состояниеЗаказаTextBox.Location = new System.Drawing.Point(177, 142);
            this.состояниеЗаказаTextBox.Name = "состояниеЗаказаTextBox";
            this.состояниеЗаказаTextBox.ReadOnly = true;
            this.состояниеЗаказаTextBox.Size = new System.Drawing.Size(100, 22);
            this.состояниеЗаказаTextBox.TabIndex = 23;
            this.состояниеЗаказаTextBox.Text = "Создан";
            // 
            // ConfirmAddButton
            // 
            this.ConfirmAddButton.Location = new System.Drawing.Point(202, 310);
            this.ConfirmAddButton.Name = "ConfirmAddButton";
            this.ConfirmAddButton.Size = new System.Drawing.Size(75, 23);
            this.ConfirmAddButton.TabIndex = 32;
            this.ConfirmAddButton.Text = "Создать";
            this.ConfirmAddButton.UseVisualStyleBackColor = true;
            this.ConfirmAddButton.Click += new System.EventHandler(this.ConfirmAddButton_Click);
            // 
            // autoserviceDataSet
            // 
            this.autoserviceDataSet.DataSetName = "AutoserviceDataSet";
            this.autoserviceDataSet.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema;
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
            // номерTextBox
            // 
            this.номерTextBox.Location = new System.Drawing.Point(190, 88);
            this.номерTextBox.Name = "номерTextBox";
            this.номерTextBox.ReadOnly = true;
            this.номерTextBox.Size = new System.Drawing.Size(68, 22);
            this.номерTextBox.TabIndex = 19;
            // 
            // panel1
            // 
            this.panel1.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.panel1.Controls.Add(this.close);
            this.panel1.Controls.Add(this.label2);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(472, 55);
            this.panel1.TabIndex = 33;
            // 
            // label2
            // 
            this.label2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F);
            this.label2.Location = new System.Drawing.Point(0, 0);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(472, 55);
            this.label2.TabIndex = 2;
            this.label2.Text = "Создание заказ-наряда";
            this.label2.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // panel2
            // 
            this.panel2.BackColor = System.Drawing.SystemColors.ControlLight;
            this.panel2.Controls.Add(this.ConfirmAddButton);
            this.panel2.Controls.Add(this.label3);
            this.panel2.Controls.Add(this.FilterField);
            this.panel2.Controls.Add(this.wINномерTextBox);
            this.panel2.Controls.Add(состояниеЗаказаLabel);
            this.panel2.Controls.Add(this.состояниеЗаказаTextBox);
            this.panel2.Controls.Add(this.датаОформленияDateTimePicker);
            this.panel2.Controls.Add(датаОформленияLabel);
            this.panel2.Controls.Add(стоимостьLabel);
            this.panel2.Controls.Add(this.стоимостьTextBox);
            this.panel2.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.panel2.Location = new System.Drawing.Point(0, 51);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(472, 400);
            this.panel2.TabIndex = 34;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(342, 84);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(86, 17);
            this.label3.TabIndex = 29;
            this.label3.Text = "Сортировка";
            // 
            // FilterField
            // 
            this.FilterField.Location = new System.Drawing.Point(335, 104);
            this.FilterField.Name = "FilterField";
            this.FilterField.Size = new System.Drawing.Size(100, 22);
            this.FilterField.TabIndex = 28;
            this.FilterField.TextChanged += new System.EventHandler(this.textBox1_TextChanged);
            // 
            // wINномерTextBox
            // 
            this.wINномерTextBox.FormattingEnabled = true;
            this.wINномерTextBox.Location = new System.Drawing.Point(120, 104);
            this.wINномерTextBox.Name = "wINномерTextBox";
            this.wINномерTextBox.Size = new System.Drawing.Size(200, 24);
            this.wINномерTextBox.TabIndex = 0;
            // 
            // Mechanic_add_form
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(472, 451);
            this.Controls.Add(механикLabel);
            this.Controls.Add(this.механикTextBox);
            this.Controls.Add(wINномерLabel);
            this.Controls.Add(номерLabel);
            this.Controls.Add(this.номерTextBox);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.panel2);
            this.Controls.Add(this.label1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "Mechanic_add_form";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Mechanic_add_form";
            this.Load += new System.EventHandler(this.Mechanic_add_form_Load);
            ((System.ComponentModel.ISupportInitialize)(this.autoserviceDataSet)).EndInit();
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.panel2.ResumeLayout(false);
            this.panel2.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label close;
        public System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox механикTextBox;
        private System.Windows.Forms.DateTimePicker датаОформленияDateTimePicker;
        private System.Windows.Forms.TextBox стоимостьTextBox;
        private System.Windows.Forms.TextBox состояниеЗаказаTextBox;
        private System.Windows.Forms.Button ConfirmAddButton;
        private AutoserviceDataSet autoserviceDataSet;
        //private System.Windows.Forms.BindingSource last_num_of_zakazBindingSource;
        private AutoserviceDataSetTableAdapters.TableAdapterManager tableAdapterManager;
        private System.Windows.Forms.TextBox номерTextBox;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Panel panel2;
        public System.Windows.Forms.ComboBox wINномерTextBox;
        private System.Windows.Forms.TextBox FilterField;
        private System.Windows.Forms.Label label3;
    }
}