
namespace КурсоваяБД
{
    partial class Archive_zakaz_details_form
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
            this.autoserviceDataSet = new КурсоваяБД.AutoserviceDataSet();
            this.list_of_detaliBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.list_of_detaliTableAdapter = new КурсоваяБД.AutoserviceDataSetTableAdapters.list_of_detaliTableAdapter();
            this.tableAdapterManager = new КурсоваяБД.AutoserviceDataSetTableAdapters.TableAdapterManager();
            this.list_of_detaliDataGridView = new System.Windows.Forms.DataGridView();
            this.dataGridViewTextBoxColumn1 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dataGridViewTextBoxColumn2 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dataGridViewTextBoxColumn5 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dataGridViewTextBoxColumn4 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dataGridViewTextBoxColumn3 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.list_of_serviceBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.list_of_serviceTableAdapter = new КурсоваяБД.AutoserviceDataSetTableAdapters.list_of_serviceTableAdapter();
            this.list_of_serviceDataGridView = new System.Windows.Forms.DataGridView();
            this.dataGridViewTextBoxColumn6 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dataGridViewTextBoxColumn7 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.label1 = new System.Windows.Forms.Label();
            this.NumField = new System.Windows.Forms.TextBox();
            this.panel1 = new System.Windows.Forms.Panel();
            this.close = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.autoserviceDataSet)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.list_of_detaliBindingSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.list_of_detaliDataGridView)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.list_of_serviceBindingSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.list_of_serviceDataGridView)).BeginInit();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // autoserviceDataSet
            // 
            this.autoserviceDataSet.DataSetName = "AutoserviceDataSet";
            this.autoserviceDataSet.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema;
            // 
            // list_of_detaliBindingSource
            // 
            this.list_of_detaliBindingSource.DataMember = "list_of_detali";
            this.list_of_detaliBindingSource.DataSource = this.autoserviceDataSet;
            // 
            // list_of_detaliTableAdapter
            // 
            this.list_of_detaliTableAdapter.ClearBeforeFill = true;
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
            // list_of_detaliDataGridView
            // 
            this.list_of_detaliDataGridView.AllowUserToAddRows = false;
            this.list_of_detaliDataGridView.AllowUserToDeleteRows = false;
            this.list_of_detaliDataGridView.AutoGenerateColumns = false;
            this.list_of_detaliDataGridView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.list_of_detaliDataGridView.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.dataGridViewTextBoxColumn1,
            this.dataGridViewTextBoxColumn2,
            this.dataGridViewTextBoxColumn5,
            this.dataGridViewTextBoxColumn4,
            this.dataGridViewTextBoxColumn3});
            this.list_of_detaliDataGridView.DataSource = this.list_of_detaliBindingSource;
            this.list_of_detaliDataGridView.Location = new System.Drawing.Point(37, 98);
            this.list_of_detaliDataGridView.Name = "list_of_detaliDataGridView";
            this.list_of_detaliDataGridView.ReadOnly = true;
            this.list_of_detaliDataGridView.RowHeadersWidth = 51;
            this.list_of_detaliDataGridView.RowTemplate.Height = 24;
            this.list_of_detaliDataGridView.Size = new System.Drawing.Size(684, 220);
            this.list_of_detaliDataGridView.TabIndex = 2;
            // 
            // dataGridViewTextBoxColumn1
            // 
            this.dataGridViewTextBoxColumn1.DataPropertyName = "Затраченная деталь";
            this.dataGridViewTextBoxColumn1.HeaderText = "Затраченная деталь";
            this.dataGridViewTextBoxColumn1.MinimumWidth = 6;
            this.dataGridViewTextBoxColumn1.Name = "dataGridViewTextBoxColumn1";
            this.dataGridViewTextBoxColumn1.ReadOnly = true;
            this.dataGridViewTextBoxColumn1.Width = 125;
            // 
            // dataGridViewTextBoxColumn2
            // 
            this.dataGridViewTextBoxColumn2.DataPropertyName = "Производитель";
            this.dataGridViewTextBoxColumn2.HeaderText = "Производитель";
            this.dataGridViewTextBoxColumn2.MinimumWidth = 6;
            this.dataGridViewTextBoxColumn2.Name = "dataGridViewTextBoxColumn2";
            this.dataGridViewTextBoxColumn2.ReadOnly = true;
            this.dataGridViewTextBoxColumn2.Width = 125;
            // 
            // dataGridViewTextBoxColumn5
            // 
            this.dataGridViewTextBoxColumn5.DataPropertyName = "Серийный номер";
            this.dataGridViewTextBoxColumn5.HeaderText = "Серийный номер";
            this.dataGridViewTextBoxColumn5.MinimumWidth = 6;
            this.dataGridViewTextBoxColumn5.Name = "dataGridViewTextBoxColumn5";
            this.dataGridViewTextBoxColumn5.ReadOnly = true;
            this.dataGridViewTextBoxColumn5.Width = 125;
            // 
            // dataGridViewTextBoxColumn4
            // 
            this.dataGridViewTextBoxColumn4.DataPropertyName = "Количество";
            this.dataGridViewTextBoxColumn4.HeaderText = "Количество";
            this.dataGridViewTextBoxColumn4.MinimumWidth = 6;
            this.dataGridViewTextBoxColumn4.Name = "dataGridViewTextBoxColumn4";
            this.dataGridViewTextBoxColumn4.ReadOnly = true;
            this.dataGridViewTextBoxColumn4.Width = 125;
            // 
            // dataGridViewTextBoxColumn3
            // 
            this.dataGridViewTextBoxColumn3.DataPropertyName = "Стоимость";
            this.dataGridViewTextBoxColumn3.HeaderText = "Стоимость";
            this.dataGridViewTextBoxColumn3.MinimumWidth = 6;
            this.dataGridViewTextBoxColumn3.Name = "dataGridViewTextBoxColumn3";
            this.dataGridViewTextBoxColumn3.ReadOnly = true;
            this.dataGridViewTextBoxColumn3.Width = 125;
            // 
            // list_of_serviceBindingSource
            // 
            this.list_of_serviceBindingSource.DataMember = "list_of_service";
            this.list_of_serviceBindingSource.DataSource = this.autoserviceDataSet;
            // 
            // list_of_serviceTableAdapter
            // 
            this.list_of_serviceTableAdapter.ClearBeforeFill = true;
            // 
            // list_of_serviceDataGridView
            // 
            this.list_of_serviceDataGridView.AllowUserToAddRows = false;
            this.list_of_serviceDataGridView.AllowUserToDeleteRows = false;
            this.list_of_serviceDataGridView.AutoGenerateColumns = false;
            this.list_of_serviceDataGridView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.list_of_serviceDataGridView.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.dataGridViewTextBoxColumn6,
            this.dataGridViewTextBoxColumn7});
            this.list_of_serviceDataGridView.DataSource = this.list_of_serviceBindingSource;
            this.list_of_serviceDataGridView.Location = new System.Drawing.Point(37, 333);
            this.list_of_serviceDataGridView.Name = "list_of_serviceDataGridView";
            this.list_of_serviceDataGridView.ReadOnly = true;
            this.list_of_serviceDataGridView.RowHeadersWidth = 51;
            this.list_of_serviceDataGridView.RowTemplate.Height = 24;
            this.list_of_serviceDataGridView.Size = new System.Drawing.Size(684, 220);
            this.list_of_serviceDataGridView.TabIndex = 3;
            // 
            // dataGridViewTextBoxColumn6
            // 
            this.dataGridViewTextBoxColumn6.DataPropertyName = "Название услуги";
            this.dataGridViewTextBoxColumn6.HeaderText = "Название услуги";
            this.dataGridViewTextBoxColumn6.MinimumWidth = 6;
            this.dataGridViewTextBoxColumn6.Name = "dataGridViewTextBoxColumn6";
            this.dataGridViewTextBoxColumn6.ReadOnly = true;
            this.dataGridViewTextBoxColumn6.Width = 400;
            // 
            // dataGridViewTextBoxColumn7
            // 
            this.dataGridViewTextBoxColumn7.DataPropertyName = "Стоимость";
            this.dataGridViewTextBoxColumn7.HeaderText = "Стоимость";
            this.dataGridViewTextBoxColumn7.MinimumWidth = 6;
            this.dataGridViewTextBoxColumn7.Name = "dataGridViewTextBoxColumn7";
            this.dataGridViewTextBoxColumn7.ReadOnly = true;
            this.dataGridViewTextBoxColumn7.Width = 125;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(42, 66);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(141, 17);
            this.label1.TabIndex = 4;
            this.label1.Text = "Заказ-наряд номер:";
            // 
            // NumField
            // 
            this.NumField.Location = new System.Drawing.Point(184, 64);
            this.NumField.Name = "NumField";
            this.NumField.ReadOnly = true;
            this.NumField.Size = new System.Drawing.Size(72, 22);
            this.NumField.TabIndex = 5;
            // 
            // panel1
            // 
            this.panel1.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.panel1.Controls.Add(this.close);
            this.panel1.Controls.Add(this.label5);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(800, 53);
            this.panel1.TabIndex = 6;
            // 
            // close
            // 
            this.close.AutoSize = true;
            this.close.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.close.Cursor = System.Windows.Forms.Cursors.Hand;
            this.close.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold);
            this.close.Location = new System.Drawing.Point(771, 2);
            this.close.Name = "close";
            this.close.Size = new System.Drawing.Size(27, 25);
            this.close.TabIndex = 11;
            this.close.Text = "X";
            this.close.TextAlign = System.Drawing.ContentAlignment.TopRight;
            this.close.Click += new System.EventHandler(this.close_Click);
            // 
            // label5
            // 
            this.label5.Dock = System.Windows.Forms.DockStyle.Fill;
            this.label5.Font = new System.Drawing.Font("Microsoft Sans Serif", 18F);
            this.label5.Location = new System.Drawing.Point(0, 0);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(800, 53);
            this.label5.TabIndex = 12;
            this.label5.Text = "Состав архивного заказ-наряда";
            this.label5.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // Archive_zakaz_details_form
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 566);
            this.Controls.Add(this.NumField);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.list_of_serviceDataGridView);
            this.Controls.Add(this.list_of_detaliDataGridView);
            this.Controls.Add(this.panel1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "Archive_zakaz_details_form";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Archive_zakaz_details_form";
            ((System.ComponentModel.ISupportInitialize)(this.autoserviceDataSet)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.list_of_detaliBindingSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.list_of_detaliDataGridView)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.list_of_serviceBindingSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.list_of_serviceDataGridView)).EndInit();
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        public AutoserviceDataSet autoserviceDataSet;
        private System.Windows.Forms.BindingSource list_of_detaliBindingSource;
        public AutoserviceDataSetTableAdapters.list_of_detaliTableAdapter list_of_detaliTableAdapter;
        private AutoserviceDataSetTableAdapters.TableAdapterManager tableAdapterManager;
        private System.Windows.Forms.DataGridView list_of_detaliDataGridView;
        private System.Windows.Forms.BindingSource list_of_serviceBindingSource;
        public AutoserviceDataSetTableAdapters.list_of_serviceTableAdapter list_of_serviceTableAdapter;
        private System.Windows.Forms.DataGridView list_of_serviceDataGridView;
        private System.Windows.Forms.Label label1;
        public System.Windows.Forms.TextBox NumField;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn1;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn2;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn5;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn4;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn3;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn6;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn7;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Label close;
        public System.Windows.Forms.Label label5;
    }
}