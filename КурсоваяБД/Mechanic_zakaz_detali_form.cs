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
    public partial class Mechanic_zakaz_detali_form : Form
    {
        public Mechanic_zakaz_detali_form()
        {
            InitializeComponent();
        }

        private void AddDetaliButton_Click(object sender, EventArgs e)
        {
            try
            {
                DB db = new DB();

                db.openConnection();
                SqlCommand command = new SqlCommand();

                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandText = "Mechanic_update_count_detali";
                command.Connection = db.getConnection();
                command.Parameters.Add("@num", SqlDbType.Int).Value = NumField.Text;
                if (CountField.Text == "")
                {
                    MessageBox.Show("Вы не ввели количество");
                }
                else
                {
                    command.Parameters.Add("@count", SqlDbType.Int).Value = CountField.Text;
                }

                command.ExecuteNonQuery();
                db.closeConnection();
                Mechanic.Current.admin_list_of_detaliTableAdapter.Fill(Mechanic.Current.autoserviceDataSet.Admin_list_of_detali);
                MessageBox.Show("Детали успешно заказаны");
            }
            catch
            {
                MessageBox.Show("Количество не может быть отрицательным!");
            }
        }

        private void close_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
