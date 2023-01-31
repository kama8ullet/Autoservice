using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace КурсоваяБД
{
    public partial class Admin_add_sort_form : Form
    {
        public Admin_add_sort_form()
        {
            InitializeComponent();
        }

        private void close_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                DB db = new DB();

                db.openConnection();
                SqlCommand command = new SqlCommand();

                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandText = "Admin_add_new_sort";
                command.Connection = db.getConnection();

                command.Parameters.Add("@fio", SqlDbType.VarChar).Value = FIOField.Text;
                command.Parameters.Add("@date", SqlDbType.Date).Value = BirthField.Text;
                command.Parameters.Add("@state", SqlDbType.VarChar).Value = StateField.Text;
                command.Parameters.Add("@salary", SqlDbType.Money).Value = SalaryField.Text;
                command.Parameters.Add("@stage", SqlDbType.Int).Value = StageField.Text;
                command.Parameters.Add("@teleph", SqlDbType.BigInt).Value = TelephField.Text;
                command.Parameters.Add("@login", SqlDbType.VarChar).Value = LoginField.Text;
                command.Parameters.Add("@pass", SqlDbType.VarChar).Value = PassField.Text;


                command.ExecuteNonQuery();
                db.closeConnection();
                Admin.Current.admin_list_of_workersTableAdapter.Fill(Admin.Current.autoserviceDataSet.Admin_list_of_workers);
                MessageBox.Show("Новый сотрудник добавлен");
            }
            catch
            {
                MessageBox.Show("Что-то пошло не так, проверьте, что:\n\n 1.Зарплата не отрицательна\n 2.Возможно такой логин уже существует\n 3.Возраст больше 18 лет\n 4.Должность существует\n 5.Стаж больше нуля\n 6.Введен телефон\n 7.нет однофалецев\n");
            }
        }
        Point lastPoint;
        private void label9_MouseMove(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                this.Left += e.X - lastPoint.X;
                this.Top += e.Y - lastPoint.Y;
            }
        }

        private void label9_MouseDown(object sender, MouseEventArgs e)
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
    }
}
