
namespace КурсоваяБД
{
    partial class Admin_edit_sort_form
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
            this.panel1 = new System.Windows.Forms.Panel();
            this.close = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.StateField = new System.Windows.Forms.ComboBox();
            this.button1 = new System.Windows.Forms.Button();
            this.BirthField = new System.Windows.Forms.DateTimePicker();
            this.PassField = new System.Windows.Forms.TextBox();
            this.label8 = new System.Windows.Forms.Label();
            this.LoginField = new System.Windows.Forms.TextBox();
            this.label7 = new System.Windows.Forms.Label();
            this.TelephField = new System.Windows.Forms.TextBox();
            this.label6 = new System.Windows.Forms.Label();
            this.StageField = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.SalaryField = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.FIOField = new System.Windows.Forms.TextBox();
            this.label9 = new System.Windows.Forms.Label();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // panel1
            // 
            this.panel1.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.panel1.Controls.Add(this.close);
            this.panel1.Controls.Add(this.label5);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(499, 61);
            this.panel1.TabIndex = 0;
            // 
            // close
            // 
            this.close.AutoSize = true;
            this.close.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.close.Cursor = System.Windows.Forms.Cursors.Hand;
            this.close.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold);
            this.close.Location = new System.Drawing.Point(470, 2);
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
            this.label5.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F);
            this.label5.Location = new System.Drawing.Point(0, 0);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(499, 61);
            this.label5.TabIndex = 2;
            this.label5.Text = "Изминение данных сотрудника";
            this.label5.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // StateField
            // 
            this.StateField.FormattingEnabled = true;
            this.StateField.Items.AddRange(new object[] {
            "Механик\t",
            "Менеджер",
            "Директор"});
            this.StateField.Location = new System.Drawing.Point(149, 165);
            this.StateField.Name = "StateField";
            this.StateField.Size = new System.Drawing.Size(121, 24);
            this.StateField.TabIndex = 38;
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(198, 388);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(90, 32);
            this.button1.TabIndex = 37;
            this.button1.Text = "Изменить";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // BirthField
            // 
            this.BirthField.Location = new System.Drawing.Point(150, 128);
            this.BirthField.Name = "BirthField";
            this.BirthField.Size = new System.Drawing.Size(200, 22);
            this.BirthField.TabIndex = 36;
            // 
            // PassField
            // 
            this.PassField.Location = new System.Drawing.Point(150, 334);
            this.PassField.Name = "PassField";
            this.PassField.ReadOnly = true;
            this.PassField.Size = new System.Drawing.Size(163, 22);
            this.PassField.TabIndex = 35;
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(88, 337);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(61, 17);
            this.label8.TabIndex = 34;
            this.label8.Text = "Пароль:";
            // 
            // LoginField
            // 
            this.LoginField.Location = new System.Drawing.Point(150, 306);
            this.LoginField.Name = "LoginField";
            this.LoginField.ReadOnly = true;
            this.LoginField.Size = new System.Drawing.Size(163, 22);
            this.LoginField.TabIndex = 33;
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(98, 309);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(51, 17);
            this.label7.TabIndex = 32;
            this.label7.Text = "Логин:";
            // 
            // TelephField
            // 
            this.TelephField.Location = new System.Drawing.Point(150, 278);
            this.TelephField.Name = "TelephField";
            this.TelephField.ReadOnly = true;
            this.TelephField.Size = new System.Drawing.Size(163, 22);
            this.TelephField.TabIndex = 31;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(77, 281);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(72, 17);
            this.label6.TabIndex = 30;
            this.label6.Text = "Телефон:";
            // 
            // StageField
            // 
            this.StageField.Location = new System.Drawing.Point(150, 240);
            this.StageField.Name = "StageField";
            this.StageField.ReadOnly = true;
            this.StageField.Size = new System.Drawing.Size(55, 22);
            this.StageField.TabIndex = 29;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(102, 243);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(45, 17);
            this.label1.TabIndex = 28;
            this.label1.Text = "Стаж:";
            // 
            // SalaryField
            // 
            this.SalaryField.Location = new System.Drawing.Point(150, 203);
            this.SalaryField.Name = "SalaryField";
            this.SalaryField.Size = new System.Drawing.Size(138, 22);
            this.SalaryField.TabIndex = 27;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(73, 206);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(76, 17);
            this.label4.TabIndex = 26;
            this.label4.Text = "Зарплата:";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(63, 168);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(85, 17);
            this.label3.TabIndex = 25;
            this.label3.Text = "Должность:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(32, 128);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(115, 17);
            this.label2.TabIndex = 24;
            this.label2.Text = "Дата рождения:";
            // 
            // FIOField
            // 
            this.FIOField.Location = new System.Drawing.Point(150, 92);
            this.FIOField.Name = "FIOField";
            this.FIOField.ReadOnly = true;
            this.FIOField.Size = new System.Drawing.Size(287, 22);
            this.FIOField.TabIndex = 23;
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(102, 95);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(46, 17);
            this.label9.TabIndex = 22;
            this.label9.Text = "ФИО:";
            // 
            // Admin_edit_sort_form
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(499, 450);
            this.Controls.Add(this.StateField);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.BirthField);
            this.Controls.Add(this.PassField);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.LoginField);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.TelephField);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.StageField);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.SalaryField);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.FIOField);
            this.Controls.Add(this.label9);
            this.Controls.Add(this.panel1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "Admin_edit_sort_form";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Admin_edit_sort_form";
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Panel panel1;
        public System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label close;
        public System.Windows.Forms.ComboBox StateField;
        private System.Windows.Forms.Button button1;
        public System.Windows.Forms.DateTimePicker BirthField;
        public System.Windows.Forms.TextBox PassField;
        private System.Windows.Forms.Label label8;
        public System.Windows.Forms.TextBox LoginField;
        private System.Windows.Forms.Label label7;
        public System.Windows.Forms.TextBox TelephField;
        private System.Windows.Forms.Label label6;
        public System.Windows.Forms.TextBox StageField;
        private System.Windows.Forms.Label label1;
        public System.Windows.Forms.TextBox SalaryField;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label2;
        public System.Windows.Forms.TextBox FIOField;
        private System.Windows.Forms.Label label9;
    }
}