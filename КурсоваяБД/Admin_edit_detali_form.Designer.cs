
namespace КурсоваяБД
{
    partial class Admin_edit_detali_form
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
            this.label1 = new System.Windows.Forms.Label();
            this.FabField = new System.Windows.Forms.TextBox();
            this.SeriesField = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.DescriptionField = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.CountField = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.FormatField = new System.Windows.Forms.TextBox();
            this.label6 = new System.Windows.Forms.Label();
            this.CostField = new System.Windows.Forms.TextBox();
            this.label7 = new System.Windows.Forms.Label();
            this.EditButton = new System.Windows.Forms.Button();
            this.NumField = new System.Windows.Forms.TextBox();
            this.label8 = new System.Windows.Forms.Label();
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
            this.panel1.Size = new System.Drawing.Size(448, 59);
            this.panel1.TabIndex = 0;
            // 
            // close
            // 
            this.close.AutoSize = true;
            this.close.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.close.Cursor = System.Windows.Forms.Cursors.Hand;
            this.close.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold);
            this.close.Location = new System.Drawing.Point(419, 2);
            this.close.Name = "close";
            this.close.Size = new System.Drawing.Size(27, 25);
            this.close.TabIndex = 13;
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
            this.label5.Size = new System.Drawing.Size(448, 59);
            this.label5.TabIndex = 14;
            this.label5.Text = "Изминение детали";
            this.label5.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(36, 120);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(114, 17);
            this.label1.TabIndex = 1;
            this.label1.Text = "Производитель:";
            // 
            // FabField
            // 
            this.FabField.Location = new System.Drawing.Point(152, 117);
            this.FabField.Name = "FabField";
            this.FabField.ReadOnly = true;
            this.FabField.Size = new System.Drawing.Size(238, 22);
            this.FabField.TabIndex = 2;
            // 
            // SeriesField
            // 
            this.SeriesField.Location = new System.Drawing.Point(152, 156);
            this.SeriesField.Name = "SeriesField";
            this.SeriesField.ReadOnly = true;
            this.SeriesField.Size = new System.Drawing.Size(165, 22);
            this.SeriesField.TabIndex = 4;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(26, 159);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(124, 17);
            this.label2.TabIndex = 3;
            this.label2.Text = "Серийный номер:";
            // 
            // DescriptionField
            // 
            this.DescriptionField.Location = new System.Drawing.Point(152, 194);
            this.DescriptionField.Name = "DescriptionField";
            this.DescriptionField.ReadOnly = true;
            this.DescriptionField.Size = new System.Drawing.Size(238, 22);
            this.DescriptionField.TabIndex = 6;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(72, 197);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(78, 17);
            this.label3.TabIndex = 5;
            this.label3.Text = "Описание:";
            // 
            // CountField
            // 
            this.CountField.Location = new System.Drawing.Point(152, 230);
            this.CountField.Name = "CountField";
            this.CountField.ReadOnly = true;
            this.CountField.Size = new System.Drawing.Size(58, 22);
            this.CountField.TabIndex = 8;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(60, 234);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(90, 17);
            this.label4.TabIndex = 7;
            this.label4.Text = "Количество:";
            // 
            // FormatField
            // 
            this.FormatField.Location = new System.Drawing.Point(152, 268);
            this.FormatField.Name = "FormatField";
            this.FormatField.ReadOnly = true;
            this.FormatField.Size = new System.Drawing.Size(85, 22);
            this.FormatField.TabIndex = 10;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(86, 272);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(63, 17);
            this.label6.TabIndex = 9;
            this.label6.Text = "Ед. Изм:";
            // 
            // CostField
            // 
            this.CostField.Location = new System.Drawing.Point(152, 306);
            this.CostField.Name = "CostField";
            this.CostField.Size = new System.Drawing.Size(110, 22);
            this.CostField.TabIndex = 12;
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(68, 309);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(82, 17);
            this.label7.TabIndex = 11;
            this.label7.Text = "Стоимость:";
            // 
            // EditButton
            // 
            this.EditButton.Location = new System.Drawing.Point(188, 351);
            this.EditButton.Name = "EditButton";
            this.EditButton.Size = new System.Drawing.Size(86, 32);
            this.EditButton.TabIndex = 13;
            this.EditButton.Text = "Изменить";
            this.EditButton.UseVisualStyleBackColor = true;
            this.EditButton.Click += new System.EventHandler(this.EditButton_Click);
            // 
            // NumField
            // 
            this.NumField.Location = new System.Drawing.Point(152, 80);
            this.NumField.Name = "NumField";
            this.NumField.ReadOnly = true;
            this.NumField.Size = new System.Drawing.Size(85, 22);
            this.NumField.TabIndex = 15;
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(94, 83);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(55, 17);
            this.label8.TabIndex = 14;
            this.label8.Text = "Номер:";
            // 
            // Admin_edit_detali_form
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(448, 401);
            this.Controls.Add(this.NumField);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.EditButton);
            this.Controls.Add(this.CostField);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.FormatField);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.CountField);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.DescriptionField);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.SeriesField);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.FabField);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.panel1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "Admin_edit_detali_form";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Admin_edit_detali_form";
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Label close;
        public System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label1;
        public System.Windows.Forms.TextBox FabField;
        public System.Windows.Forms.TextBox SeriesField;
        private System.Windows.Forms.Label label2;
        public System.Windows.Forms.TextBox DescriptionField;
        private System.Windows.Forms.Label label3;
        public System.Windows.Forms.TextBox CountField;
        private System.Windows.Forms.Label label4;
        public System.Windows.Forms.TextBox FormatField;
        private System.Windows.Forms.Label label6;
        public System.Windows.Forms.TextBox CostField;
        private System.Windows.Forms.Label label7;
        public System.Windows.Forms.Button EditButton;
        public System.Windows.Forms.TextBox NumField;
        private System.Windows.Forms.Label label8;
    }
}