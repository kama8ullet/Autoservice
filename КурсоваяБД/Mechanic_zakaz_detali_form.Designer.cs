
namespace КурсоваяБД
{
    partial class Mechanic_zakaz_detali_form
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
            this.FormatField = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.CountField = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.AddDetaliButton = new System.Windows.Forms.Button();
            this.label3 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.SeriesField = new System.Windows.Forms.TextBox();
            this.FabField = new System.Windows.Forms.TextBox();
            this.TypeField = new System.Windows.Forms.TextBox();
            this.NumField = new System.Windows.Forms.TextBox();
            this.label6 = new System.Windows.Forms.Label();
            this.panel1 = new System.Windows.Forms.Panel();
            this.close = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // FormatField
            // 
            this.FormatField.Location = new System.Drawing.Point(148, 281);
            this.FormatField.Name = "FormatField";
            this.FormatField.ReadOnly = true;
            this.FormatField.Size = new System.Drawing.Size(100, 22);
            this.FormatField.TabIndex = 31;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(38, 284);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(111, 17);
            this.label5.TabIndex = 30;
            this.label5.Text = "Ед. Измерения:";
            // 
            // CountField
            // 
            this.CountField.Location = new System.Drawing.Point(148, 247);
            this.CountField.Name = "CountField";
            this.CountField.Size = new System.Drawing.Size(100, 22);
            this.CountField.TabIndex = 29;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(60, 250);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(90, 17);
            this.label4.TabIndex = 28;
            this.label4.Text = "Количество:";
            // 
            // AddDetaliButton
            // 
            this.AddDetaliButton.Location = new System.Drawing.Point(189, 342);
            this.AddDetaliButton.Name = "AddDetaliButton";
            this.AddDetaliButton.Size = new System.Drawing.Size(92, 32);
            this.AddDetaliButton.TabIndex = 27;
            this.AddDetaliButton.Text = "Заказать";
            this.AddDetaliButton.UseVisualStyleBackColor = true;
            this.AddDetaliButton.Click += new System.EventHandler(this.AddDetaliButton_Click);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(28, 211);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(124, 17);
            this.label3.TabIndex = 26;
            this.label3.Text = "Серийный номер:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(38, 171);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(114, 17);
            this.label2.TabIndex = 25;
            this.label2.Text = "Производитель:";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(64, 128);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(88, 17);
            this.label1.TabIndex = 24;
            this.label1.Text = "Тип детали:";
            // 
            // SeriesField
            // 
            this.SeriesField.Location = new System.Drawing.Point(148, 211);
            this.SeriesField.Name = "SeriesField";
            this.SeriesField.ReadOnly = true;
            this.SeriesField.Size = new System.Drawing.Size(262, 22);
            this.SeriesField.TabIndex = 32;
            // 
            // FabField
            // 
            this.FabField.Location = new System.Drawing.Point(148, 170);
            this.FabField.Name = "FabField";
            this.FabField.ReadOnly = true;
            this.FabField.Size = new System.Drawing.Size(262, 22);
            this.FabField.TabIndex = 33;
            // 
            // TypeField
            // 
            this.TypeField.Location = new System.Drawing.Point(148, 128);
            this.TypeField.Name = "TypeField";
            this.TypeField.ReadOnly = true;
            this.TypeField.Size = new System.Drawing.Size(262, 22);
            this.TypeField.TabIndex = 34;
            // 
            // NumField
            // 
            this.NumField.Location = new System.Drawing.Point(152, 91);
            this.NumField.Name = "NumField";
            this.NumField.ReadOnly = true;
            this.NumField.Size = new System.Drawing.Size(59, 22);
            this.NumField.TabIndex = 35;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(100, 95);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(55, 17);
            this.label6.TabIndex = 36;
            this.label6.Text = "Номер:";
            // 
            // panel1
            // 
            this.panel1.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.panel1.Controls.Add(this.close);
            this.panel1.Controls.Add(this.label7);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(471, 58);
            this.panel1.TabIndex = 37;
            // 
            // close
            // 
            this.close.AutoSize = true;
            this.close.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.close.Cursor = System.Windows.Forms.Cursors.Hand;
            this.close.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold);
            this.close.Location = new System.Drawing.Point(442, 2);
            this.close.Name = "close";
            this.close.Size = new System.Drawing.Size(27, 25);
            this.close.TabIndex = 38;
            this.close.Text = "X";
            this.close.TextAlign = System.Drawing.ContentAlignment.TopRight;
            this.close.Click += new System.EventHandler(this.close_Click);
            // 
            // label7
            // 
            this.label7.Dock = System.Windows.Forms.DockStyle.Fill;
            this.label7.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F);
            this.label7.Location = new System.Drawing.Point(0, 0);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(471, 58);
            this.label7.TabIndex = 39;
            this.label7.Text = "Заказ запчасти\\материала";
            this.label7.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // Mechanic_zakaz_detali_form
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(471, 401);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.NumField);
            this.Controls.Add(this.TypeField);
            this.Controls.Add(this.FabField);
            this.Controls.Add(this.SeriesField);
            this.Controls.Add(this.FormatField);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.CountField);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.AddDetaliButton);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.panel1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "Mechanic_zakaz_detali_form";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Mechanic_zakaz_detali_form";
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        public System.Windows.Forms.TextBox FormatField;
        private System.Windows.Forms.Label label5;
        public System.Windows.Forms.TextBox CountField;
        private System.Windows.Forms.Label label4;
        public System.Windows.Forms.Button AddDetaliButton;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label1;
        public System.Windows.Forms.TextBox SeriesField;
        public System.Windows.Forms.TextBox FabField;
        public System.Windows.Forms.TextBox TypeField;
        public System.Windows.Forms.TextBox NumField;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Label close;
        private System.Windows.Forms.Label label7;
    }
}