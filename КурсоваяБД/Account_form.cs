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
    public partial class Account_form : Form
    {
        public Account_form()
        {
            InitializeComponent();
        }

        private void Account_form_Load(object sender, EventArgs e)
        {

            this.account_dataTableAdapter.Fill(this.autoserviceDataSet.account_data, FIOField.Text);
            this.list_of_daysTableAdapter.Fill(this.autoserviceDataSet.list_of_days, FIOField.Text);
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
                command.CommandText = "account_edit_data";
                command.Connection = db.getConnection();

                command.Parameters.Add("@fio", SqlDbType.VarChar).Value = FIOField.Text;
                command.Parameters.Add("@date", SqlDbType.DateTime).Value = датаРожденияDateTimePicker.Text;
                command.Parameters.Add("@teleph", SqlDbType.BigInt).Value = телефонTextBox.Text;
                command.Parameters.Add("@login", SqlDbType.VarChar).Value = логинTextBox.Text;
                command.Parameters.Add("@pass", SqlDbType.VarChar).Value = парольTextBox.Text;


                command.ExecuteNonQuery();
                db.closeConnection();
                this.account_dataTableAdapter.Fill(this.autoserviceDataSet.account_data, FIOField.Text);
                MessageBox.Show("Изминения выполнены успешно!");
            }
            catch
            {
                MessageBox.Show("Что-то пошло не так, проверьте что:\n\n 1. Вы совершеннолетний\n 2. Логин не совпадает с другими\n 3. Телефон введен корректно");
            }
        }

        /*private void button2_Click(object sender, EventArgs e)
        {
            list_of_daysBindingSource.Filter = "ДатаСмены Like '" + DateField.Text + "%'";
        }

        private void button3_Click(object sender, EventArgs e)
        {
            list_of_daysBindingSource.Filter = "";
        }*/
    }
}
