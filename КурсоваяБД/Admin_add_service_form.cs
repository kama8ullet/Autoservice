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
    public partial class Admin_add_service_form : Form
    {
        public Admin_add_service_form()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                DB db = new DB();

                db.openConnection();
                SqlCommand command = new SqlCommand();

                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandText = "Admin_add_service";
                command.Connection = db.getConnection();

                command.Parameters.Add("@name", SqlDbType.VarChar).Value = ServiceNameField.Text;
                command.Parameters.Add("@description", SqlDbType.VarChar).Value = DescriptionField.Text;
                command.Parameters.Add("@cost", SqlDbType.Money).Value = CostField.Text;

                command.ExecuteNonQuery();
                db.closeConnection();
                Admin.Current.admin_list_of_serviceTableAdapter.Fill(Admin.Current.autoserviceDataSet.Admin_list_of_service);
                MessageBox.Show("Новая услуга добавлена");
            }
            catch
            {
                MessageBox.Show("Что-то пошло не так, проверьте:\n1. Нет ли уже такой услуги\n2. Стоимость меньше нуля");
            }
        }

        private void close_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
