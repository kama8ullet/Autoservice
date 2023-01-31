
namespace КурсоваяБД
{
    partial class Account_form
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
            System.Windows.Forms.Label датаРожденияLabel;
            System.Windows.Forms.Label должностьLabel;
            System.Windows.Forms.Label зарплатаLabel;
            System.Windows.Forms.Label стажLabel;
            System.Windows.Forms.Label телефонLabel;
            System.Windows.Forms.Label логинLabel;
            System.Windows.Forms.Label парольLabel;
            this.close = new System.Windows.Forms.Label();
            this.panel1 = new System.Windows.Forms.Panel();
            this.label5 = new System.Windows.Forms.Label();
            this.tabControl1 = new System.Windows.Forms.TabControl();
            this.tabPage1 = new System.Windows.Forms.TabPage();
            this.list_of_daysDataGridView = new System.Windows.Forms.DataGridView();
            this.dataGridViewTextBoxColumn1 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dataGridViewTextBoxColumn2 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dataGridViewTextBoxColumn3 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.list_of_daysBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.autoserviceDataSet = new КурсоваяБД.AutoserviceDataSet();
            this.tabPage2 = new System.Windows.Forms.TabPage();
            this.парольTextBox = new System.Windows.Forms.TextBox();
            this.account_dataBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.логинTextBox = new System.Windows.Forms.TextBox();
            this.телефонTextBox = new System.Windows.Forms.TextBox();
            this.стажTextBox = new System.Windows.Forms.TextBox();
            this.зарплатаTextBox = new System.Windows.Forms.TextBox();
            this.должностьTextBox = new System.Windows.Forms.TextBox();
            this.датаРожденияDateTimePicker = new System.Windows.Forms.DateTimePicker();
            this.button1 = new System.Windows.Forms.Button();
            this.FIOField = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.account_dataTableAdapter = new КурсоваяБД.AutoserviceDataSetTableAdapters.account_dataTableAdapter();
            this.tableAdapterManager = new КурсоваяБД.AutoserviceDataSetTableAdapters.TableAdapterManager();
            this.list_of_daysTableAdapter = new КурсоваяБД.AutoserviceDataSetTableAdapters.list_of_daysTableAdapter();
            датаРожденияLabel = new System.Windows.Forms.Label();
            должностьLabel = new System.Windows.Forms.Label();
            зарплатаLabel = new System.Windows.Forms.Label();
            стажLabel = new System.Windows.Forms.Label();
            телефонLabel = new System.Windows.Forms.Label();
            логинLabel = new System.Windows.Forms.Label();
            парольLabel = new System.Windows.Forms.Label();
            this.panel1.SuspendLayout();
            this.tabControl1.SuspendLayout();
            this.tabPage1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.list_of_daysDataGridView)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.list_of_daysBindingSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.autoserviceDataSet)).BeginInit();
            this.tabPage2.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.account_dataBindingSource)).BeginInit();
            this.SuspendLayout();
            // 
            // датаРожденияLabel
            // 
            датаРожденияLabel.AutoSize = true;
            датаРожденияLabel.Location = new System.Drawing.Point(54, 61);
            датаРожденияLabel.Name = "датаРожденияLabel";
            датаРожденияLabel.Size = new System.Drawing.Size(116, 17);
            датаРожденияLabel.TabIndex = 38;
            датаРожденияLabel.Text = "Дата Рождения:";
            // 
            // должностьLabel
            // 
            должностьLabel.AutoSize = true;
            должностьLabel.Location = new System.Drawing.Point(85, 87);
            должностьLabel.Name = "должностьLabel";
            должностьLabel.Size = new System.Drawing.Size(85, 17);
            должностьLabel.TabIndex = 39;
            должностьLabel.Text = "Должность:";
            // 
            // зарплатаLabel
            // 
            зарплатаLabel.AutoSize = true;
            зарплатаLabel.Location = new System.Drawing.Point(94, 115);
            зарплатаLabel.Name = "зарплатаLabel";
            зарплатаLabel.Size = new System.Drawing.Size(76, 17);
            зарплатаLabel.TabIndex = 40;
            зарплатаLabel.Text = "Зарплата:";
            // 
            // стажLabel
            // 
            стажLabel.AutoSize = true;
            стажLabel.Location = new System.Drawing.Point(125, 149);
            стажLabel.Name = "стажLabel";
            стажLabel.Size = new System.Drawing.Size(45, 17);
            стажLabel.TabIndex = 41;
            стажLabel.Text = "Стаж:";
            // 
            // телефонLabel
            // 
            телефонLabel.AutoSize = true;
            телефонLabel.Location = new System.Drawing.Point(98, 179);
            телефонLabel.Name = "телефонLabel";
            телефонLabel.Size = new System.Drawing.Size(72, 17);
            телефонLabel.TabIndex = 42;
            телефонLabel.Text = "Телефон:";
            // 
            // логинLabel
            // 
            логинLabel.AutoSize = true;
            логинLabel.Location = new System.Drawing.Point(119, 209);
            логинLabel.Name = "логинLabel";
            логинLabel.Size = new System.Drawing.Size(51, 17);
            логинLabel.TabIndex = 43;
            логинLabel.Text = "Логин:";
            // 
            // парольLabel
            // 
            парольLabel.AutoSize = true;
            парольLabel.Location = new System.Drawing.Point(109, 237);
            парольLabel.Name = "парольLabel";
            парольLabel.Size = new System.Drawing.Size(61, 17);
            парольLabel.TabIndex = 44;
            парольLabel.Text = "Пароль:";
            // 
            // close
            // 
            this.close.AutoSize = true;
            this.close.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.close.Cursor = System.Windows.Forms.Cursors.Hand;
            this.close.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold);
            this.close.Location = new System.Drawing.Point(581, 2);
            this.close.Name = "close";
            this.close.Size = new System.Drawing.Size(27, 25);
            this.close.TabIndex = 16;
            this.close.Text = "X";
            this.close.TextAlign = System.Drawing.ContentAlignment.TopRight;
            this.close.Click += new System.EventHandler(this.close_Click);
            // 
            // panel1
            // 
            this.panel1.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.panel1.Controls.Add(this.close);
            this.panel1.Controls.Add(this.label5);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(610, 53);
            this.panel1.TabIndex = 17;
            // 
            // label5
            // 
            this.label5.Dock = System.Windows.Forms.DockStyle.Fill;
            this.label5.Font = new System.Drawing.Font("Microsoft Sans Serif", 18F);
            this.label5.Location = new System.Drawing.Point(0, 0);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(610, 53);
            this.label5.TabIndex = 17;
            this.label5.Text = "Личный кабинет";
            this.label5.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // tabControl1
            // 
            this.tabControl1.Controls.Add(this.tabPage1);
            this.tabControl1.Controls.Add(this.tabPage2);
            this.tabControl1.Location = new System.Drawing.Point(3, 59);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new System.Drawing.Size(609, 390);
            this.tabControl1.TabIndex = 18;
            // 
            // tabPage1
            // 
            this.tabPage1.Controls.Add(this.list_of_daysDataGridView);
            this.tabPage1.Location = new System.Drawing.Point(4, 25);
            this.tabPage1.Name = "tabPage1";
            this.tabPage1.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage1.Size = new System.Drawing.Size(601, 361);
            this.tabPage1.TabIndex = 0;
            this.tabPage1.Text = "Смены";
            this.tabPage1.UseVisualStyleBackColor = true;
            // 
            // list_of_daysDataGridView
            // 
            this.list_of_daysDataGridView.AllowUserToAddRows = false;
            this.list_of_daysDataGridView.AllowUserToDeleteRows = false;
            this.list_of_daysDataGridView.AutoGenerateColumns = false;
            this.list_of_daysDataGridView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.list_of_daysDataGridView.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.dataGridViewTextBoxColumn1,
            this.dataGridViewTextBoxColumn2,
            this.dataGridViewTextBoxColumn3});
            this.list_of_daysDataGridView.DataSource = this.list_of_daysBindingSource;
            this.list_of_daysDataGridView.Location = new System.Drawing.Point(6, 6);
            this.list_of_daysDataGridView.Name = "list_of_daysDataGridView";
            this.list_of_daysDataGridView.ReadOnly = true;
            this.list_of_daysDataGridView.RowHeadersWidth = 51;
            this.list_of_daysDataGridView.RowTemplate.Height = 24;
            this.list_of_daysDataGridView.Size = new System.Drawing.Size(589, 228);
            this.list_of_daysDataGridView.TabIndex = 0;
            // 
            // dataGridViewTextBoxColumn1
            // 
            this.dataGridViewTextBoxColumn1.DataPropertyName = "ФИОраб";
            this.dataGridViewTextBoxColumn1.HeaderText = "ФИО";
            this.dataGridViewTextBoxColumn1.MinimumWidth = 6;
            this.dataGridViewTextBoxColumn1.Name = "dataGridViewTextBoxColumn1";
            this.dataGridViewTextBoxColumn1.ReadOnly = true;
            this.dataGridViewTextBoxColumn1.Width = 250;
            // 
            // dataGridViewTextBoxColumn2
            // 
            this.dataGridViewTextBoxColumn2.DataPropertyName = "ДатаСмены";
            this.dataGridViewTextBoxColumn2.HeaderText = "Дата смены";
            this.dataGridViewTextBoxColumn2.MinimumWidth = 6;
            this.dataGridViewTextBoxColumn2.Name = "dataGridViewTextBoxColumn2";
            this.dataGridViewTextBoxColumn2.ReadOnly = true;
            this.dataGridViewTextBoxColumn2.Width = 125;
            // 
            // dataGridViewTextBoxColumn3
            // 
            this.dataGridViewTextBoxColumn3.DataPropertyName = "ЧасыРаботы";
            this.dataGridViewTextBoxColumn3.HeaderText = "Часы работы";
            this.dataGridViewTextBoxColumn3.MinimumWidth = 6;
            this.dataGridViewTextBoxColumn3.Name = "dataGridViewTextBoxColumn3";
            this.dataGridViewTextBoxColumn3.ReadOnly = true;
            this.dataGridViewTextBoxColumn3.Width = 125;
            // 
            // list_of_daysBindingSource
            // 
            this.list_of_daysBindingSource.DataMember = "list_of_days";
            this.list_of_daysBindingSource.DataSource = this.autoserviceDataSet;
            // 
            // autoserviceDataSet
            // 
            this.autoserviceDataSet.DataSetName = "AutoserviceDataSet";
            this.autoserviceDataSet.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema;
            // 
            // tabPage2
            // 
            this.tabPage2.Controls.Add(парольLabel);
            this.tabPage2.Controls.Add(this.парольTextBox);
            this.tabPage2.Controls.Add(логинLabel);
            this.tabPage2.Controls.Add(this.логинTextBox);
            this.tabPage2.Controls.Add(телефонLabel);
            this.tabPage2.Controls.Add(this.телефонTextBox);
            this.tabPage2.Controls.Add(стажLabel);
            this.tabPage2.Controls.Add(this.стажTextBox);
            this.tabPage2.Controls.Add(зарплатаLabel);
            this.tabPage2.Controls.Add(this.зарплатаTextBox);
            this.tabPage2.Controls.Add(должностьLabel);
            this.tabPage2.Controls.Add(this.должностьTextBox);
            this.tabPage2.Controls.Add(датаРожденияLabel);
            this.tabPage2.Controls.Add(this.датаРожденияDateTimePicker);
            this.tabPage2.Controls.Add(this.button1);
            this.tabPage2.Controls.Add(this.FIOField);
            this.tabPage2.Controls.Add(this.label1);
            this.tabPage2.Location = new System.Drawing.Point(4, 25);
            this.tabPage2.Name = "tabPage2";
            this.tabPage2.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage2.Size = new System.Drawing.Size(601, 361);
            this.tabPage2.TabIndex = 1;
            this.tabPage2.Text = "Личные данные";
            this.tabPage2.UseVisualStyleBackColor = true;
            // 
            // парольTextBox
            // 
            this.парольTextBox.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.account_dataBindingSource, "Пароль", true));
            this.парольTextBox.Location = new System.Drawing.Point(176, 234);
            this.парольTextBox.Name = "парольTextBox";
            this.парольTextBox.Size = new System.Drawing.Size(100, 22);
            this.парольTextBox.TabIndex = 45;
            // 
            // account_dataBindingSource
            // 
            this.account_dataBindingSource.DataMember = "account_data";
            this.account_dataBindingSource.DataSource = this.autoserviceDataSet;
            // 
            // логинTextBox
            // 
            this.логинTextBox.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.account_dataBindingSource, "Логин", true));
            this.логинTextBox.Location = new System.Drawing.Point(176, 206);
            this.логинTextBox.Name = "логинTextBox";
            this.логинTextBox.Size = new System.Drawing.Size(100, 22);
            this.логинTextBox.TabIndex = 44;
            // 
            // телефонTextBox
            // 
            this.телефонTextBox.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.account_dataBindingSource, "Телефон", true));
            this.телефонTextBox.Location = new System.Drawing.Point(176, 176);
            this.телефонTextBox.Name = "телефонTextBox";
            this.телефонTextBox.Size = new System.Drawing.Size(200, 22);
            this.телефонTextBox.TabIndex = 43;
            // 
            // стажTextBox
            // 
            this.стажTextBox.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.account_dataBindingSource, "Стаж", true));
            this.стажTextBox.Location = new System.Drawing.Point(176, 146);
            this.стажTextBox.Name = "стажTextBox";
            this.стажTextBox.ReadOnly = true;
            this.стажTextBox.Size = new System.Drawing.Size(59, 22);
            this.стажTextBox.TabIndex = 42;
            // 
            // зарплатаTextBox
            // 
            this.зарплатаTextBox.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.account_dataBindingSource, "Зарплата", true));
            this.зарплатаTextBox.Location = new System.Drawing.Point(176, 112);
            this.зарплатаTextBox.Name = "зарплатаTextBox";
            this.зарплатаTextBox.ReadOnly = true;
            this.зарплатаTextBox.Size = new System.Drawing.Size(139, 22);
            this.зарплатаTextBox.TabIndex = 41;
            // 
            // должностьTextBox
            // 
            this.должностьTextBox.DataBindings.Add(new System.Windows.Forms.Binding("Text", this.account_dataBindingSource, "Должность", true));
            this.должностьTextBox.Location = new System.Drawing.Point(176, 84);
            this.должностьTextBox.Name = "должностьTextBox";
            this.должностьTextBox.ReadOnly = true;
            this.должностьTextBox.Size = new System.Drawing.Size(139, 22);
            this.должностьTextBox.TabIndex = 40;
            // 
            // датаРожденияDateTimePicker
            // 
            this.датаРожденияDateTimePicker.DataBindings.Add(new System.Windows.Forms.Binding("Value", this.account_dataBindingSource, "ДатаРождения", true));
            this.датаРожденияDateTimePicker.Location = new System.Drawing.Point(176, 57);
            this.датаРожденияDateTimePicker.Name = "датаРожденияDateTimePicker";
            this.датаРожденияDateTimePicker.Size = new System.Drawing.Size(200, 22);
            this.датаРожденияDateTimePicker.TabIndex = 39;
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(241, 298);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(90, 32);
            this.button1.TabIndex = 37;
            this.button1.Text = "Изменить";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // FIOField
            // 
            this.FIOField.Location = new System.Drawing.Point(172, 25);
            this.FIOField.Name = "FIOField";
            this.FIOField.ReadOnly = true;
            this.FIOField.Size = new System.Drawing.Size(287, 22);
            this.FIOField.TabIndex = 23;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(124, 28);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(46, 17);
            this.label1.TabIndex = 22;
            this.label1.Text = "ФИО:";
            // 
            // account_dataTableAdapter
            // 
            this.account_dataTableAdapter.ClearBeforeFill = true;
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
            // list_of_daysTableAdapter
            // 
            this.list_of_daysTableAdapter.ClearBeforeFill = true;
            // 
            // Account_form
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(610, 450);
            this.Controls.Add(this.tabControl1);
            this.Controls.Add(this.panel1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "Account_form";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Account_form";
            this.Load += new System.EventHandler(this.Account_form_Load);
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.tabControl1.ResumeLayout(false);
            this.tabPage1.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.list_of_daysDataGridView)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.list_of_daysBindingSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.autoserviceDataSet)).EndInit();
            this.tabPage2.ResumeLayout(false);
            this.tabPage2.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.account_dataBindingSource)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Label close;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.TabControl tabControl1;
        private System.Windows.Forms.TabPage tabPage1;
        private System.Windows.Forms.TabPage tabPage2;
        private System.Windows.Forms.Button button1;
        public System.Windows.Forms.TextBox FIOField;
        private System.Windows.Forms.Label label1;
        private AutoserviceDataSet autoserviceDataSet;
        private System.Windows.Forms.BindingSource account_dataBindingSource;
        private AutoserviceDataSetTableAdapters.account_dataTableAdapter account_dataTableAdapter;
        private AutoserviceDataSetTableAdapters.TableAdapterManager tableAdapterManager;
        private System.Windows.Forms.TextBox парольTextBox;
        private System.Windows.Forms.TextBox логинTextBox;
        private System.Windows.Forms.TextBox телефонTextBox;
        private System.Windows.Forms.TextBox стажTextBox;
        private System.Windows.Forms.TextBox зарплатаTextBox;
        private System.Windows.Forms.TextBox должностьTextBox;
        private System.Windows.Forms.DateTimePicker датаРожденияDateTimePicker;
        private System.Windows.Forms.BindingSource list_of_daysBindingSource;
        private AutoserviceDataSetTableAdapters.list_of_daysTableAdapter list_of_daysTableAdapter;
        private System.Windows.Forms.DataGridView list_of_daysDataGridView;
        public System.Windows.Forms.Label label5;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn1;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn2;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn3;
    }
}