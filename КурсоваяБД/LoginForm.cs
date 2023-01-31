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

namespace КурсоваяБД
{
    public partial class LoginForm : Form
    {
        public static LoginForm Current;
        public LoginForm()
        {
            Current = this;
            InitializeComponent();
            this.SetStyle(ControlStyles.SupportsTransparentBackColor, true);
            this.passField.AutoSize = false;
            this.passField.Size = new Size(this.passField.Size.Width, 45);

            loginField.Text = "Логин";
            passField.Text = "Пароль";
            loginField.ForeColor = Color.LightGray;
            passField.ForeColor = Color.LightGray;
        }

        private void close_MouseClick(object sender, MouseEventArgs e)
        {
            this.Close();
        }

        Point lastPoint;
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



        private void pictureBox4_Click(object sender, EventArgs e)
        {
            string loginUser = loginField.Text;
            string passUser = passField.Text;

            DB db = new DB();

            DataTable table = new DataTable();

            SqlDataAdapter adapter = new SqlDataAdapter();

            SqlCommand command = new SqlCommand("select * from Работник Where Логин = @uL and Пароль = @uP", db.getConnection());
            command.Parameters.Add("@uL", SqlDbType.VarChar).Value = loginUser;
            command.Parameters.Add("@uP", SqlDbType.VarChar).Value = passUser;

            adapter.SelectCommand = command;
            adapter.Fill(table);

            if (table.Rows.Count == 1 && table.Rows[0][2].ToString() == "Директор")
            {
                //MessageBox.Show("Авторизация прошла успешно");
                Admin admin = new Admin();
                admin.label1.Text = ("Директор " + table.Rows[0][0].ToString());
                admin.Show();
                this.Hide();
                

            }
            else if (table.Rows.Count == 1 && table.Rows[0][2].ToString() == "Механик")
            {
                //MessageBox.Show("Авторизация прошла успешно");
                Mechanic Mech = new Mechanic();
                Mech.label1.Text = ("Механик " + table.Rows[0][0].ToString());
                Mech.Show();
                this.Hide();

            }
            else if (table.Rows.Count == 1 && table.Rows[0][2].ToString() == "Менеджер")
            {
                //MessageBox.Show("Авторизация прошла успешно");
                Manager manager = new Manager();
                manager.label1.Text = ("Менеджер " + table.Rows[0][0].ToString());
                manager.Show();
                this.Hide();
            }
            else
            {
                MessageBox.Show("Данные введены неверно");
            }
        }

        private void pictureBox3_Click(object sender, EventArgs e)
        {
            this.Hide();
            Registration registration = new Registration();
            registration.Show();
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
    }
}
