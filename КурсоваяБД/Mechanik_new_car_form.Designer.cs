
namespace КурсоваяБД
{
    partial class Mechanik_new_car_form
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
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.FIOMechField = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.WINField = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.FabField = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.ModelField = new System.Windows.Forms.TextBox();
            this.AddButton = new System.Windows.Forms.Button();
            this.NewClientCheck = new System.Windows.Forms.CheckBox();
            this.FIOClientField = new System.Windows.Forms.ComboBox();
            this.panel1 = new System.Windows.Forms.Panel();
            this.close = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(58, 138);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(104, 17);
            this.label1.TabIndex = 1;
            this.label1.Text = "ФИО клиента:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(51, 181);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(112, 17);
            this.label2.TabIndex = 3;
            this.label2.Text = "ФИО механика:";
            // 
            // FIOMechField
            // 
            this.FIOMechField.Location = new System.Drawing.Point(164, 178);
            this.FIOMechField.Name = "FIOMechField";
            this.FIOMechField.ReadOnly = true;
            this.FIOMechField.Size = new System.Drawing.Size(228, 22);
            this.FIOMechField.TabIndex = 2;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(79, 97);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(83, 17);
            this.label3.TabIndex = 5;
            this.label3.Text = "WIN номер:";
            // 
            // WINField
            // 
            this.WINField.Location = new System.Drawing.Point(164, 94);
            this.WINField.Name = "WINField";
            this.WINField.Size = new System.Drawing.Size(228, 22);
            this.WINField.TabIndex = 4;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(107, 224);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(54, 17);
            this.label4.TabIndex = 7;
            this.label4.Text = "Марка:";
            // 
            // FabField
            // 
            this.FabField.Location = new System.Drawing.Point(164, 221);
            this.FabField.Name = "FabField";
            this.FabField.ReadOnly = true;
            this.FabField.Size = new System.Drawing.Size(228, 22);
            this.FabField.TabIndex = 6;
            this.FabField.Text = "Hyundai";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(100, 267);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(62, 17);
            this.label5.TabIndex = 9;
            this.label5.Text = "Модель:";
            // 
            // ModelField
            // 
            this.ModelField.Location = new System.Drawing.Point(164, 264);
            this.ModelField.Name = "ModelField";
            this.ModelField.Size = new System.Drawing.Size(228, 22);
            this.ModelField.TabIndex = 8;
            // 
            // AddButton
            // 
            this.AddButton.Location = new System.Drawing.Point(246, 327);
            this.AddButton.Name = "AddButton";
            this.AddButton.Size = new System.Drawing.Size(80, 31);
            this.AddButton.TabIndex = 10;
            this.AddButton.Text = "Добавить";
            this.AddButton.UseVisualStyleBackColor = true;
            this.AddButton.Click += new System.EventHandler(this.AddButton_Click);
            // 
            // NewClientCheck
            // 
            this.NewClientCheck.AutoSize = true;
            this.NewClientCheck.Checked = true;
            this.NewClientCheck.CheckState = System.Windows.Forms.CheckState.Checked;
            this.NewClientCheck.Location = new System.Drawing.Point(399, 135);
            this.NewClientCheck.Name = "NewClientCheck";
            this.NewClientCheck.Size = new System.Drawing.Size(123, 21);
            this.NewClientCheck.TabIndex = 11;
            this.NewClientCheck.Text = "Новый клиент";
            this.NewClientCheck.UseVisualStyleBackColor = true;
            this.NewClientCheck.CheckedChanged += new System.EventHandler(this.NewClientCheck_CheckedChanged);
            // 
            // FIOClientField
            // 
            this.FIOClientField.FormattingEnabled = true;
            this.FIOClientField.Location = new System.Drawing.Point(169, 135);
            this.FIOClientField.Name = "FIOClientField";
            this.FIOClientField.Size = new System.Drawing.Size(223, 24);
            this.FIOClientField.TabIndex = 12;
            // 
            // panel1
            // 
            this.panel1.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.panel1.Controls.Add(this.close);
            this.panel1.Controls.Add(this.label6);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(553, 57);
            this.panel1.TabIndex = 13;
            // 
            // close
            // 
            this.close.AutoSize = true;
            this.close.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.close.Cursor = System.Windows.Forms.Cursors.Hand;
            this.close.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold);
            this.close.Location = new System.Drawing.Point(524, 2);
            this.close.Name = "close";
            this.close.Size = new System.Drawing.Size(27, 25);
            this.close.TabIndex = 14;
            this.close.Text = "X";
            this.close.TextAlign = System.Drawing.ContentAlignment.TopRight;
            this.close.Click += new System.EventHandler(this.close_Click);
            // 
            // label6
            // 
            this.label6.Dock = System.Windows.Forms.DockStyle.Fill;
            this.label6.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F);
            this.label6.Location = new System.Drawing.Point(0, 0);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(553, 57);
            this.label6.TabIndex = 15;
            this.label6.Text = "Добавление транспортного средства";
            this.label6.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // Mechanik_new_car_form
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(553, 397);
            this.Controls.Add(this.FIOClientField);
            this.Controls.Add(this.NewClientCheck);
            this.Controls.Add(this.AddButton);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.ModelField);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.FabField);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.WINField);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.FIOMechField);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.panel1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "Mechanik_new_car_form";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Mechanik_new_car_form";
            this.Load += new System.EventHandler(this.Mechanik_new_car_form_Load);
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        public System.Windows.Forms.TextBox FIOMechField;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox WINField;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox FabField;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TextBox ModelField;
        private System.Windows.Forms.Button AddButton;
        private System.Windows.Forms.CheckBox NewClientCheck;
        private System.Windows.Forms.ComboBox FIOClientField;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Label close;
        public System.Windows.Forms.Label label6;
    }
}