
namespace КурсоваяБД
{
    partial class Registration
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
            this.loginField = new System.Windows.Forms.TextBox();
            this.panel1 = new System.Windows.Forms.Panel();
            this.BackToLoginButton = new System.Windows.Forms.PictureBox();
            this.CloseButton = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.panel2 = new System.Windows.Forms.Panel();
            this.PositionField = new System.Windows.Forms.TextBox();
            this.PosotionPic = new System.Windows.Forms.PictureBox();
            this.BirthdayField = new System.Windows.Forms.TextBox();
            this.BirhtdayPic = new System.Windows.Forms.PictureBox();
            this.FioField = new System.Windows.Forms.TextBox();
            this.FioPic = new System.Windows.Forms.PictureBox();
            this.EntryButton = new System.Windows.Forms.PictureBox();
            this.passField = new System.Windows.Forms.TextBox();
            this.PassPic = new System.Windows.Forms.PictureBox();
            this.LoginPic = new System.Windows.Forms.PictureBox();
            this.panel1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.BackToLoginButton)).BeginInit();
            this.panel2.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.PosotionPic)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.BirhtdayPic)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.FioPic)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.EntryButton)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.PassPic)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.LoginPic)).BeginInit();
            this.SuspendLayout();
            // 
            // loginField
            // 
            this.loginField.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.loginField.Font = new System.Drawing.Font("Times New Roman", 20F);
            this.loginField.Location = new System.Drawing.Point(146, 280);
            this.loginField.Multiline = true;
            this.loginField.Name = "loginField";
            this.loginField.Size = new System.Drawing.Size(226, 45);
            this.loginField.TabIndex = 2;
            this.loginField.Enter += new System.EventHandler(this.loginField_Enter);
            this.loginField.Leave += new System.EventHandler(this.loginField_Leave);
            // 
            // panel1
            // 
            this.panel1.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.panel1.Controls.Add(this.BackToLoginButton);
            this.panel1.Controls.Add(this.CloseButton);
            this.panel1.Controls.Add(this.label1);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(800, 80);
            this.panel1.TabIndex = 2;
            // 
            // BackToLoginButton
            // 
            this.BackToLoginButton.Cursor = System.Windows.Forms.Cursors.Hand;
            this.BackToLoginButton.Image = global::КурсоваяБД.Properties.Resources.image;
            this.BackToLoginButton.Location = new System.Drawing.Point(0, 0);
            this.BackToLoginButton.Name = "BackToLoginButton";
            this.BackToLoginButton.Size = new System.Drawing.Size(50, 50);
            this.BackToLoginButton.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.BackToLoginButton.TabIndex = 6;
            this.BackToLoginButton.TabStop = false;
            this.BackToLoginButton.Click += new System.EventHandler(this.BackToLoginButton_Click);
            // 
            // CloseButton
            // 
            this.CloseButton.AutoSize = true;
            this.CloseButton.Cursor = System.Windows.Forms.Cursors.Hand;
            this.CloseButton.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold);
            this.CloseButton.Location = new System.Drawing.Point(771, 2);
            this.CloseButton.Name = "CloseButton";
            this.CloseButton.Size = new System.Drawing.Size(27, 25);
            this.CloseButton.TabIndex = 1;
            this.CloseButton.Text = "X";
            this.CloseButton.TextAlign = System.Drawing.ContentAlignment.TopRight;
            this.CloseButton.Click += new System.EventHandler(this.CloseButton_Click);
            // 
            // label1
            // 
            this.label1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 24F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label1.Location = new System.Drawing.Point(0, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(800, 80);
            this.label1.TabIndex = 0;
            this.label1.Text = "Регистрация";
            this.label1.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            this.label1.MouseDown += new System.Windows.Forms.MouseEventHandler(this.label1_MouseDown);
            this.label1.MouseMove += new System.Windows.Forms.MouseEventHandler(this.label1_MouseMove);
            // 
            // panel2
            // 
            this.panel2.BackColor = System.Drawing.SystemColors.ControlLight;
            this.panel2.Controls.Add(this.PositionField);
            this.panel2.Controls.Add(this.PosotionPic);
            this.panel2.Controls.Add(this.BirthdayField);
            this.panel2.Controls.Add(this.BirhtdayPic);
            this.panel2.Controls.Add(this.FioField);
            this.panel2.Controls.Add(this.FioPic);
            this.panel2.Controls.Add(this.EntryButton);
            this.panel2.Controls.Add(this.passField);
            this.panel2.Controls.Add(this.PassPic);
            this.panel2.Controls.Add(this.loginField);
            this.panel2.Controls.Add(this.LoginPic);
            this.panel2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel2.Location = new System.Drawing.Point(0, 0);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(800, 450);
            this.panel2.TabIndex = 3;
            this.panel2.MouseDown += new System.Windows.Forms.MouseEventHandler(this.panel2_MouseDown);
            this.panel2.MouseMove += new System.Windows.Forms.MouseEventHandler(this.panel2_MouseMove);
            // 
            // PositionField
            // 
            this.PositionField.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.PositionField.Font = new System.Drawing.Font("Times New Roman", 20F);
            this.PositionField.Location = new System.Drawing.Point(515, 192);
            this.PositionField.Multiline = true;
            this.PositionField.Name = "PositionField";
            this.PositionField.Size = new System.Drawing.Size(226, 45);
            this.PositionField.TabIndex = 12;
            this.PositionField.Enter += new System.EventHandler(this.PositionField_Enter);
            this.PositionField.Leave += new System.EventHandler(this.PositionField_Leave);
            // 
            // PosotionPic
            // 
            this.PosotionPic.Image = global::КурсоваяБД.Properties.Resources.posotion;
            this.PosotionPic.Location = new System.Drawing.Point(428, 173);
            this.PosotionPic.Name = "PosotionPic";
            this.PosotionPic.Size = new System.Drawing.Size(70, 70);
            this.PosotionPic.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.PosotionPic.TabIndex = 11;
            this.PosotionPic.TabStop = false;
            // 
            // BirthdayField
            // 
            this.BirthdayField.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.BirthdayField.Font = new System.Drawing.Font("Times New Roman", 20F);
            this.BirthdayField.Location = new System.Drawing.Point(146, 192);
            this.BirthdayField.Multiline = true;
            this.BirthdayField.Name = "BirthdayField";
            this.BirthdayField.Size = new System.Drawing.Size(226, 45);
            this.BirthdayField.TabIndex = 10;
            this.BirthdayField.Enter += new System.EventHandler(this.BirthdayField_Enter);
            this.BirthdayField.Leave += new System.EventHandler(this.BirthdayField_Leave);
            // 
            // BirhtdayPic
            // 
            this.BirhtdayPic.Image = global::КурсоваяБД.Properties.Resources.date;
            this.BirhtdayPic.Location = new System.Drawing.Point(54, 173);
            this.BirhtdayPic.Name = "BirhtdayPic";
            this.BirhtdayPic.Size = new System.Drawing.Size(70, 70);
            this.BirhtdayPic.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.BirhtdayPic.TabIndex = 9;
            this.BirhtdayPic.TabStop = false;
            // 
            // FioField
            // 
            this.FioField.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.FioField.Font = new System.Drawing.Font("Times New Roman", 20F);
            this.FioField.Location = new System.Drawing.Point(146, 111);
            this.FioField.Multiline = true;
            this.FioField.Name = "FioField";
            this.FioField.Size = new System.Drawing.Size(595, 45);
            this.FioField.TabIndex = 8;
            this.FioField.Enter += new System.EventHandler(this.FioField_Enter);
            this.FioField.Leave += new System.EventHandler(this.FioField_Leave);
            // 
            // FioPic
            // 
            this.FioPic.Image = global::КурсоваяБД.Properties.Resources.fio;
            this.FioPic.Location = new System.Drawing.Point(54, 97);
            this.FioPic.Name = "FioPic";
            this.FioPic.Size = new System.Drawing.Size(70, 70);
            this.FioPic.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.FioPic.TabIndex = 7;
            this.FioPic.TabStop = false;
            // 
            // EntryButton
            // 
            this.EntryButton.Cursor = System.Windows.Forms.Cursors.Hand;
            this.EntryButton.Image = global::КурсоваяБД.Properties.Resources.enter;
            this.EntryButton.Location = new System.Drawing.Point(363, 356);
            this.EntryButton.Name = "EntryButton";
            this.EntryButton.Size = new System.Drawing.Size(85, 85);
            this.EntryButton.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.EntryButton.TabIndex = 6;
            this.EntryButton.TabStop = false;
            this.EntryButton.Click += new System.EventHandler(this.EntryButton_Click);
            // 
            // passField
            // 
            this.passField.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.passField.Font = new System.Drawing.Font("Times New Roman", 20F);
            this.passField.Location = new System.Drawing.Point(515, 280);
            this.passField.Name = "passField";
            this.passField.Size = new System.Drawing.Size(226, 39);
            this.passField.TabIndex = 4;
            this.passField.UseSystemPasswordChar = true;
            this.passField.Enter += new System.EventHandler(this.passField_Enter);
            this.passField.Leave += new System.EventHandler(this.passField_Leave);
            // 
            // PassPic
            // 
            this.PassPic.Image = global::КурсоваяБД.Properties.Resources.pass2;
            this.PassPic.Location = new System.Drawing.Point(428, 268);
            this.PassPic.Name = "PassPic";
            this.PassPic.Size = new System.Drawing.Size(70, 70);
            this.PassPic.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.PassPic.TabIndex = 3;
            this.PassPic.TabStop = false;
            // 
            // LoginPic
            // 
            this.LoginPic.Image = global::КурсоваяБД.Properties.Resources.login;
            this.LoginPic.Location = new System.Drawing.Point(54, 268);
            this.LoginPic.Name = "LoginPic";
            this.LoginPic.Size = new System.Drawing.Size(70, 70);
            this.LoginPic.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.LoginPic.TabIndex = 0;
            this.LoginPic.TabStop = false;
            // 
            // Registration
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.panel2);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "Registration";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Registration";
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.BackToLoginButton)).EndInit();
            this.panel2.ResumeLayout(false);
            this.panel2.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.PosotionPic)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.BirhtdayPic)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.FioPic)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.EntryButton)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.PassPic)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.LoginPic)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.TextBox loginField;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.PictureBox BackToLoginButton;
        private System.Windows.Forms.Label CloseButton;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.PictureBox EntryButton;
        private System.Windows.Forms.TextBox passField;
        private System.Windows.Forms.PictureBox PassPic;
        private System.Windows.Forms.PictureBox LoginPic;
        private System.Windows.Forms.TextBox FioField;
        private System.Windows.Forms.PictureBox FioPic;
        private System.Windows.Forms.TextBox BirthdayField;
        private System.Windows.Forms.PictureBox BirhtdayPic;
        private System.Windows.Forms.TextBox PositionField;
        private System.Windows.Forms.PictureBox PosotionPic;
        private System.Windows.Forms.Label label1;
    }
}