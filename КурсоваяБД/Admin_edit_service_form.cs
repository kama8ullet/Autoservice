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
    public partial class Admin_edit_service_form : Form
    {
        public Admin_edit_service_form()
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
                command.CommandText = "Admin_edit_service";
                command.Connection = db.getConnection();
                //@name varchar(50), @des varchar(50), @cost money
                command.Parameters.Add("@name", SqlDbType.VarChar).Value = NameField.Text;
                command.Parameters.Add("@des", SqlDbType.VarChar).Value = DescriptionField.Text;
                command.Parameters.Add("@cost", SqlDbType.Money).Value = CostField.Text;

                command.ExecuteNonQuery();
                db.closeConnection();
                Admin.Current.admin_list_of_serviceTableAdapter.Fill(Admin.Current.autoserviceDataSet.Admin_list_of_service);
                MessageBox.Show("Изминения выполнены успешно!");
            }
            catch
            {
                MessageBox.Show("Стоимость услуги не может быть отрицательной!");
            }
        }
    }
}
