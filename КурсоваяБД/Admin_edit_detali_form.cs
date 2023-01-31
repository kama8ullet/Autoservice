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
    public partial class Admin_edit_detali_form : Form
    {
        public Admin_edit_detali_form()
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
                command.CommandText = "Admin_edit_detali";
                command.Connection = db.getConnection();
                //@num int, @cost money
                command.Parameters.Add("@num", SqlDbType.Int).Value = NumField.Text;
                command.Parameters.Add("@cost", SqlDbType.Money).Value = CostField.Text;

                command.ExecuteNonQuery();
                db.closeConnection();
                Admin.Current.admin_list_of_detaliTableAdapter.Fill(Admin.Current.autoserviceDataSet.Admin_list_of_detali);
                MessageBox.Show("Изминения выполнены успешно!");
            }
            catch
            {
                MessageBox.Show("Стоимость запчасти не может быть отрицательной!");
            }
        }
    }
}
