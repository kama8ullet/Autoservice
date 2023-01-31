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
    public partial class Mechanic_add_form : Form
    {
        public Mechanic_add_form()
        {
            InitializeComponent();
        }

        private void close_Click(object sender, EventArgs e)
        {
            //Mechanic Mech = new Mechanic();
            //Mech.label1.Text = (this.label1.Text);
           // Mech.Show();
            this.Close();
        }

        private void Mechanic_add_form_Load(object sender, EventArgs e)
        {
            string name = this.label1.Text;
            name = name.Remove(0, name.IndexOf(' ') + 1);
            механикTextBox.Text = name;
            
            DB db = new DB();

            db.openConnection();
            SqlCommand command = new SqlCommand();

            command.CommandType = System.Data.CommandType.StoredProcedure;
            command.CommandText = "last_num";
            command.Connection = db.getConnection();

            command.Parameters.Add("@num", SqlDbType.Int);
            command.Parameters["@num"].Direction = ParameterDirection.Output;

            command.ExecuteNonQuery();
           
            db.closeConnection();

            int result = (int)command.Parameters["@num"].Value;
            номерTextBox.Text = Convert.ToString(result);
            //
            //
            //
            db.openConnection();
            SqlCommand command2 = new SqlCommand();

            command2.CommandType = System.Data.CommandType.StoredProcedure;
            command2.CommandText = "diagnostic_cost";
            command2.Connection = db.getConnection();

            command2.Parameters.Add("@cost", SqlDbType.Int);
            command2.Parameters["@cost"].Direction = ParameterDirection.Output;

            command2.ExecuteNonQuery();

            db.closeConnection();

            int result2 = (int)command2.Parameters["@cost"].Value;
            стоимостьTextBox.Text = Convert.ToString(result2);


        }

        private void ConfirmAddButton_Click(object sender, EventArgs e)
        {
            try
            {
                DB db = new DB();

                db.openConnection();
                SqlCommand command = new SqlCommand();

                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandText = "add_new_zakaz";
                command.Connection = db.getConnection();

                command.Parameters.Add("@num", SqlDbType.Int).Value = номерTextBox.Text;
                command.Parameters.Add("@name", SqlDbType.VarChar).Value = механикTextBox.Text;
                command.Parameters.Add("@win", SqlDbType.VarChar).Value = wINномерTextBox.Text;
                command.Parameters.Add("@sost", SqlDbType.VarChar).Value = состояниеЗаказаTextBox.Text;
                command.Parameters.Add("@cost", SqlDbType.Money).Value = стоимостьTextBox.Text;
                command.Parameters.Add("@date", SqlDbType.Date).Value = датаОформленияDateTimePicker.Text;

                command.ExecuteNonQuery();
                db.closeConnection();
                Mechanic.Current.mechanic_list_of_ordersTableAdapter.Fill(Mechanic.Current.autoserviceDataSet.Mechanic_list_of_orders, механикTextBox.Text);
                MessageBox.Show("Заказ-наряд создан");
            }
            catch
            {
                MessageBox.Show("Что-то пошло не так, проверьте что:\n\n 1.Введена корректная дата\n 2.Такой win номер существует");
            }

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {
            DB db = new DB();

            db.openConnection();
            SqlCommand command = new SqlCommand();

            command.CommandType = System.Data.CommandType.StoredProcedure;
            command.CommandText = "filter_wincode";
            command.Connection = db.getConnection();

            command.Parameters.Add("@win", SqlDbType.VarChar).Value = FilterField.Text;

            DataTable table = new DataTable();

            SqlDataAdapter adapter = new SqlDataAdapter();

            
            adapter.SelectCommand = command;
            adapter.Fill(table);
            wINномерTextBox.DataSource = table;
            wINномерTextBox.DisplayMember = "WINномер";
            command.ExecuteNonQuery();
            db.closeConnection();
        }
    }
}
