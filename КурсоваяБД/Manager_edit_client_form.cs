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
    public partial class Manager_edit_client_form : Form
    {
        public Manager_edit_client_form()
        {
            InitializeComponent();
        }

        private void close_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void EditButton_Click(object sender, EventArgs e)
        {
            try
            {
                DB db = new DB();

                db.openConnection();
                SqlCommand command = new SqlCommand();

                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandText = "manager_edit_client";
                command.Connection = db.getConnection();

                command.Parameters.Add("@fio", SqlDbType.VarChar).Value = FIOField.Text;
                command.Parameters.Add("@date", SqlDbType.Date).Value = DateField.Text;
                command.Parameters.Add("@gender", SqlDbType.Char).Value = GenderField.Text;
                command.Parameters.Add("@teleph", SqlDbType.BigInt).Value = TelephField.Text;

                command.ExecuteNonQuery();
                db.closeConnection();
                Manager.Current.manager_list_of_clientsTableAdapter.Fill(Manager.Current.autoserviceDataSet.Manager_list_of_clients);
                MessageBox.Show("Изминения выполнены успешно!");
            }
            catch
            {
                MessageBox.Show("Что-то пошло нет так, проверьте что:\n\n 1.Клиент совершеннолений\n 2.Пол введен корректно\n 3.Телефон введен корректно");
            }

        }
    }
}
