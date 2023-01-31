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
    public partial class Manager_edit_or_delete_zapisi_form : Form
    {
        public Manager_edit_or_delete_zapisi_form()
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
                command.CommandText = "Manager_update_zapasi";
                command.Connection = db.getConnection();
                //@num int, @date date
                command.Parameters.Add("@num", SqlDbType.Int).Value = NumField.Text;
                command.Parameters.Add("@date", SqlDbType.Date).Value = dateTimePicker1.Text;

                command.ExecuteNonQuery();
                db.closeConnection();

                Manager.Current.manager_list_of_zapisiTableAdapter.Fill(Manager.Current.autoserviceDataSet.Manager_list_of_zapisi);

                MessageBox.Show("Изминения выполнены успешно!");
            }
            catch
            {
                MessageBox.Show("Что - то пошло не так, проверьте, что:\n\n 1.Выбранная дата сущесвует и не занята");
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            DB db = new DB();

            db.openConnection();
            SqlCommand command = new SqlCommand();

            command.CommandType = System.Data.CommandType.StoredProcedure;
            command.CommandText = "Manager_delete_zapisi";
            command.Connection = db.getConnection();
            //@num int
            command.Parameters.Add("@num", SqlDbType.Int).Value = NumField.Text;
            
            command.ExecuteNonQuery();
            db.closeConnection();

            Manager.Current.manager_list_of_zapisiTableAdapter.Fill(Manager.Current.autoserviceDataSet.Manager_list_of_zapisi);

            MessageBox.Show("Удаление выполнено успешно!");
            this.Close();
        }
    }
}
