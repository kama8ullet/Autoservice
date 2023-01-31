
namespace КурсоваяБД
{
    partial class Admin_add_detali
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
            this.NumField = new System.Windows.Forms.TextBox();
            this.FabField = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.SeriesField = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.DescriptionField = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.CountField = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.CostField = new System.Windows.Forms.TextBox();
            this.label7 = new System.Windows.Forms.Label();
            this.AddButton = new System.Windows.Forms.Button();
            this.panel1 = new System.Windows.Forms.Panel();
            this.close = new System.Windows.Forms.Label();
            this.label8 = new System.Windows.Forms.Label();
            this.EdIzmField = new System.Windows.Forms.ComboBox();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(46, 80);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(106, 17);
            this.label1.TabIndex = 0;
            this.label1.Text = "Номер детали:";
            // 
            // NumField
            // 
            this.NumField.Location = new System.Drawing.Point(153, 77);
            this.NumField.Name = "NumField";
            this.NumField.ReadOnly = true;
            this.NumField.Size = new System.Drawing.Size(64, 22);
            this.NumField.TabIndex = 1;
            // 
            // FabField
            // 
            this.FabField.Location = new System.Drawing.Point(153, 116);
            this.FabField.Name = "FabField";
            this.FabField.Size = new System.Drawing.Size(185, 22);
            this.FabField.TabIndex = 3;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(38, 118);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(114, 17);
            this.label2.TabIndex = 2;
            this.label2.Text = "Производитель:";
            // 
            // SeriesField
            // 
            this.SeriesField.Location = new System.Drawing.Point(153, 157);
            this.SeriesField.Name = "SeriesField";
            this.SeriesField.Size = new System.Drawing.Size(185, 22);
            this.SeriesField.TabIndex = 5;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(28, 160);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(124, 17);
            this.label3.TabIndex = 4;
            this.label3.Text = "Серийный номер:";
            // 
            // DescriptionField
            // 
            this.DescriptionField.Location = new System.Drawing.Point(153, 202);
            this.DescriptionField.Name = "DescriptionField";
            this.DescriptionField.Size = new System.Drawing.Size(185, 22);
            this.DescriptionField.TabIndex = 7;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(73, 205);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(78, 17);
            this.label4.TabIndex = 6;
            this.label4.Text = "Описание:";
            // 
            // CountField
            // 
            this.CountField.Location = new System.Drawing.Point(153, 246);
            this.CountField.Name = "CountField";
            this.CountField.Size = new System.Drawing.Size(64, 22);
            this.CountField.TabIndex = 9;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(62, 249);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(90, 17);
            this.label5.TabIndex = 8;
            this.label5.Text = "Количество:";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(88, 296);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(63, 17);
            this.label6.TabIndex = 10;
            this.label6.Text = "Ед. Изм:";
            // 
            // CostField
            // 
            this.CostField.Location = new System.Drawing.Point(153, 337);
            this.CostField.Name = "CostField";
            this.CostField.Size = new System.Drawing.Size(100, 22);
            this.CostField.TabIndex = 13;
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(74, 340);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(78, 17);
            this.label7.TabIndex = 12;
            this.label7.Text = "Стоимость";
            // 
            // AddButton
            // 
            this.AddButton.Location = new System.Drawing.Point(181, 393);
            this.AddButton.Name = "AddButton";
            this.AddButton.Size = new System.Drawing.Size(83, 30);
            this.AddButton.TabIndex = 14;
            this.AddButton.Text = "Добавить";
            this.AddButton.UseVisualStyleBackColor = true;
            this.AddButton.Click += new System.EventHandler(this.AddButton_Click);
            // 
            // panel1
            // 
            this.panel1.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.panel1.Controls.Add(this.close);
            this.panel1.Controls.Add(this.label8);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(421, 56);
            this.panel1.TabIndex = 15;
            // 
            // close
            // 
            this.close.AutoSize = true;
            this.close.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.close.Cursor = System.Windows.Forms.Cursors.Hand;
            this.close.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold);
            this.close.Location = new System.Drawing.Point(394, 0);
            this.close.Name = "close";
            this.close.Size = new System.Drawing.Size(27, 25);
            this.close.TabIndex = 16;
            this.close.Text = "X";
            this.close.TextAlign = System.Drawing.ContentAlignment.TopRight;
            this.close.Click += new System.EventHandler(this.close_Click);
            // 
            // label8
            // 
            this.label8.Dock = System.Windows.Forms.DockStyle.Fill;
            this.label8.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F);
            this.label8.Location = new System.Drawing.Point(0, 0);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(421, 56);
            this.label8.TabIndex = 17;
            this.label8.Text = "Добавление детали";
            this.label8.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // EdIzmField
            // 
            this.EdIzmField.FormattingEnabled = true;
            this.EdIzmField.Items.AddRange(new object[] {
            "Штука",
            "Литр"});
            this.EdIzmField.Location = new System.Drawing.Point(153, 293);
            this.EdIzmField.Name = "EdIzmField";
            this.EdIzmField.Size = new System.Drawing.Size(95, 24);
            this.EdIzmField.TabIndex = 16;
            // 
            // Admin_add_detali
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(421, 450);
            this.Controls.Add(this.EdIzmField);
            this.Controls.Add(this.AddButton);
            this.Controls.Add(this.CostField);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.CountField);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.DescriptionField);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.SeriesField);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.FabField);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.NumField);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.panel1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "Admin_add_detali";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Admin_add_detali";
            this.Load += new System.EventHandler(this.Admin_add_detali_Load);
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox NumField;
        private System.Windows.Forms.TextBox FabField;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox SeriesField;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox DescriptionField;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox CountField;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.TextBox CostField;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Button AddButton;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Label close;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.ComboBox EdIzmField;
    }
}