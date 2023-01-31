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
    public partial class Admin_edit_sort_form : Form
    {
        public Admin_edit_sort_form()
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
                command.CommandText = "Admin_edit_sotr";
                command.Connection = db.getConnection();

                command.Parameters.Add("@fio", SqlDbType.VarChar).Value = FIOField.Text;
                command.Parameters.Add("@pos", SqlDbType.VarChar).Value = StateField.Text;
                command.Parameters.Add("@salary", SqlDbType.Money).Value = SalaryField.Text;


                command.ExecuteNonQuery();
                db.closeConnection();
                Admin.Current.admin_list_of_workersTableAdapter.Fill(Admin.Current.autoserviceDataSet.Admin_list_of_workers);
                MessageBox.Show("Изминения выполнены успешно!");
            }
            catch
            {
                MessageBox.Show("Что-то пошло не так, проверьте что:\n\n 1.Зарплата не отрицательная\n 2.Должность указана верно\n 3.Сотрудник совершеннолетний");
            }
        }
    }
}
