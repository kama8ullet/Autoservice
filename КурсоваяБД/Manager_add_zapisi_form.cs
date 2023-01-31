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
    public partial class Manager_add_zapisi_form : Form
    {
        public Manager_add_zapisi_form()
        {
            InitializeComponent();
        }

        private void close_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void Manager_add_zapisi_form_Load(object sender, EventArgs e)
        {

            DB db = new DB();

            db.openConnection();
            SqlCommand command = new SqlCommand();

            command.CommandType = System.Data.CommandType.StoredProcedure;
            command.CommandText = "last_num_zapisi";
            command.Connection = db.getConnection();

            command.Parameters.Add("@num", SqlDbType.Int);
            command.Parameters["@num"].Direction = ParameterDirection.Output;

            command.ExecuteNonQuery();

            db.closeConnection();

            int result = (int)command.Parameters["@num"].Value;
            NumField.Text = Convert.ToString(result);

           
            SqlDataAdapter adapter = new SqlDataAdapter();

            SqlCommand command1 = new SqlCommand("select ФИОклиент from Запись", db.getConnection());
            DataTable table1 = new DataTable();
            adapter.SelectCommand = command1;
            adapter.Fill(table1);
            FioClientField.DataSource = table1;
            FioClientField.DisplayMember = "ФИОклиент";
        }

        private void AddButton_Click(object sender, EventArgs e)
        {
            try
            {
                DB db = new DB();

                db.openConnection();

                SqlCommand command = new SqlCommand();

                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandText = "Manager_add_new_zapisi";
                command.Connection = db.getConnection();

                command.Parameters.Add("@num", SqlDbType.Int).Value = NumField.Text;
                command.Parameters.Add("@fio", SqlDbType.VarChar).Value = FioClientField.Text;
                command.Parameters.Add("@date", SqlDbType.VarChar).Value = dateTimePicker1.Text;

                command.ExecuteNonQuery();
                db.closeConnection();

                Manager.Current.manager_list_of_zapisiTableAdapter.Fill(Manager.Current.autoserviceDataSet.Manager_list_of_zapisi);

                MessageBox.Show("Запись клиента успешно создана!");
               
            }
            catch
            {
                MessageBox.Show("Что-то пошло не так, проверьте, что:\n\n 1.Такой клиент существует в базе\n 2.Выбранная дата актуальна");
            }

            DB db1 = new DB();
            db1.openConnection();
            SqlCommand command1 = new SqlCommand();
            command1.CommandType = System.Data.CommandType.StoredProcedure;
            command1.CommandText = "last_num_zapisi";
            command1.Connection = db1.getConnection();

            command1.Parameters.Add("@num", SqlDbType.Int);
            command1.Parameters["@num"].Direction = ParameterDirection.Output;

            command1.ExecuteNonQuery();

            db1.closeConnection();

            int result = (int)command1.Parameters["@num"].Value;
            NumField.Text = Convert.ToString(result);
        }
    }
}
