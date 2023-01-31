using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Globalization;

namespace КурсоваяБД
{
    public partial class Registration : Form
    {
        public Registration()
        {
            InitializeComponent();
            this.passField.AutoSize = false;
            this.passField.Size = new Size(this.passField.Size.Width, 45);

            PositionField.Text = "Должность";
            BirthdayField.Text = "ДР";
            FioField.Text = "Введите ФИО";
            loginField.Text = "Логин";
            passField.Text = "Пароль";


            FioField.ForeColor = Color.LightGray;
            BirthdayField.ForeColor = Color.LightGray;
            PositionField.ForeColor = Color.LightGray;
            loginField.ForeColor = Color.LightGray;
            passField.ForeColor = Color.LightGray;
        }

        private void BackToLoginButton_Click(object sender, EventArgs e)
        {
            this.Hide();
            LoginForm.Current.Show();
        }

        private void CloseButton_Click(object sender, EventArgs e)
        {
            this.Close();
            LoginForm.Current.Close();
        }
        Point lastPoint;
        private void label1_MouseMove(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                this.Left += e.X - lastPoint.X;
                this.Top += e.Y - lastPoint.Y;
            }
        }

        private void label1_MouseDown(object sender, MouseEventArgs e)
        {
            lastPoint = new Point(e.X, e.Y);
        }

        private void panel2_MouseMove(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                this.Left += e.X - lastPoint.X;
                this.Top += e.Y - lastPoint.Y;
            }
        }

        private void panel2_MouseDown(object sender, MouseEventArgs e)
        {
            lastPoint = new Point(e.X, e.Y);
        }

        private void FioField_Enter(object sender, EventArgs e)
        {
            if (FioField.Text == "Введите ФИО")
            {
                FioField.Text = "";
                FioField.ForeColor = Color.Black;
            }
        }

        private void FioField_Leave(object sender, EventArgs e)
        {
            if (FioField.Text == "")
            {
                FioField.Text = "Введите ФИО";
                FioField.ForeColor = Color.LightGray;
            }
        }

        private void BirthdayField_Enter(object sender, EventArgs e)
        {
            if (BirthdayField.Text == "ДР")
            {
                BirthdayField.Text = "";
                BirthdayField.ForeColor = Color.Black;
            }
        }

        private void BirthdayField_Leave(object sender, EventArgs e)
        {
            if (BirthdayField.Text == "")
            {
                BirthdayField.Text = "ДР";
                BirthdayField.ForeColor = Color.LightGray;
            }
        }

        private void PositionField_Enter(object sender, EventArgs e)
        {
            if (PositionField.Text == "Должность")
            {
                PositionField.Text = "";
                PositionField.ForeColor = Color.Black;
            }
        }

        private void PositionField_Leave(object sender, EventArgs e)
        {
            if (PositionField.Text == "")
            {
                PositionField.Text = "Должность";
                PositionField.ForeColor = Color.LightGray;
            }
        }

        private void loginField_Enter(object sender, EventArgs e)
        {
            if (loginField.Text == "Логин")
            {
                loginField.Text = "";
                loginField.ForeColor = Color.Black;
            }
        }

        private void loginField_Leave(object sender, EventArgs e)
        {
            if (loginField.Text == "")
            {
                loginField.Text = "Логин";
                loginField.ForeColor = Color.LightGray;
            }
        }

        private void passField_Enter(object sender, EventArgs e)
        {
            if (passField.Text == "Пароль")
            {
                passField.Text = "";
                passField.ForeColor = Color.Black;
            }
        }

        private void passField_Leave(object sender, EventArgs e)
        {
            if (passField.Text == "")
            {
                passField.Text = "Пароль";
                passField.ForeColor = Color.LightGray;
            }
        }

        private void EntryButton_Click(object sender, EventArgs e)
        {
            if (FioField.Text == "Введите ФИО" || passField.Text == "Пароль" || loginField.Text == "Логин" || PositionField.Text == "Должность" || BirthdayField.Text == "ДР")
            {
                MessageBox.Show("Проверьте поля ввода");
                return;
            }

            if (isUserExists())
                return;

            if (isPositionCorrect())
                return;

            if (isDateCorrect())
                return;

            DB db = new DB();
            SqlCommand command = new SqlCommand("Insert into Работник (ФИО,ДатаРождения,Должность,Логин,Пароль) values (@fio,@birth,@pos,@login,@pass)", db.getConnection());

            command.Parameters.Add("@fio", SqlDbType.VarChar).Value = FioField.Text;
            command.Parameters.Add("@birth", SqlDbType.Date).Value = BirthdayField.Text;
            command.Parameters.Add("@pos", SqlDbType.VarChar).Value = PositionField.Text;
            command.Parameters.Add("@login", SqlDbType.VarChar).Value = loginField.Text;
            command.Parameters.Add("@pass", SqlDbType.VarChar).Value = passField.Text;

            db.openConnection();

            if (command.ExecuteNonQuery() == 1) 
            {
                MessageBox.Show("Аккаунт был создан");
                FioField.Text = "";

            }
            else
                MessageBox.Show("Аккаунт не был создан");

            db.closeConnection();
        }
        static Boolean TextIsDate(string text)
        {
            var dateFormat = "dd.MM.yyyy";
            DateTime scheduleDate;
            if (DateTime.TryParseExact(text, dateFormat, DateTimeFormatInfo.InvariantInfo, DateTimeStyles.None, out scheduleDate))
            {
                return true;
            }
            return false;
        }
        public Boolean isDateCorrect()
        {

            if (TextIsDate(BirthdayField.Text))
            {   

                return false;
            }
            else
            {
                MessageBox.Show("Текст не является датой");
                return true;
            }
        }
        public Boolean isPositionCorrect()
        {
            if (PositionField.Text == "Директор" || PositionField.Text == "Механик" || PositionField.Text == "Менеджер")
            {
                return false;
            }
            else
                MessageBox.Show("Должность введена некорректно\n1. Механик\n2. Менеджер\n3. Директор");
                return true;
        }

        public Boolean isUserExists()
        {
            DB db = new DB();

            DataTable table = new DataTable();

            SqlDataAdapter adapter = new SqlDataAdapter();

            SqlCommand command = new SqlCommand("select * from Работник Where Логин = @uL or ФИО = @fio", db.getConnection());
            command.Parameters.Add("@uL", SqlDbType.VarChar).Value = loginField.Text;
            command.Parameters.Add("@fio", SqlDbType.VarChar).Value = FioField.Text;

            adapter.SelectCommand = command;
            adapter.Fill(table);
            if (table.Rows.Count > 0)
            {
                MessageBox.Show("Такой пользователь уже зарегистрирован");
                return true;
            }
            else
                return false;
        }
    }
}
