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
    public partial class Admin_add_detali : Form
    {
        public Admin_add_detali()
        {
            InitializeComponent();
        }

        private void Admin_add_detali_Load(object sender, EventArgs e)
        {
            DB db = new DB();

            db.openConnection();
            SqlCommand command = new SqlCommand();

            command.CommandType = System.Data.CommandType.StoredProcedure;
            command.CommandText = "last_num_detali";
            command.Connection = db.getConnection();

            command.Parameters.Add("@num", SqlDbType.Int);
            command.Parameters["@num"].Direction = ParameterDirection.Output;

            command.ExecuteNonQuery();

            db.closeConnection();

            int result = (int)command.Parameters["@num"].Value;
            NumField.Text = Convert.ToString(result);
        }

        private void AddButton_Click(object sender, EventArgs e)
        {
            try
            {
                DB db = new DB();

                db.openConnection();
                SqlCommand command = new SqlCommand();

                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandText = "admin_add_detali";
                command.Connection = db.getConnection();

                command.Parameters.Add("@num", SqlDbType.Int).Value = NumField.Text;
                command.Parameters.Add("@fab", SqlDbType.VarChar).Value = FabField.Text;
                command.Parameters.Add("@series", SqlDbType.VarChar).Value = SeriesField.Text;
                command.Parameters.Add("@description", SqlDbType.VarChar).Value = DescriptionField.Text;
                command.Parameters.Add("@count", SqlDbType.Int).Value = CountField.Text;
                command.Parameters.Add("@EdIzm", SqlDbType.VarChar).Value = EdIzmField.Text;
                command.Parameters.Add("@cost", SqlDbType.Money).Value = CostField.Text;

                command.ExecuteNonQuery();
                db.closeConnection();
                Admin.Current.admin_list_of_detaliTableAdapter.Fill(Admin.Current.autoserviceDataSet.Admin_list_of_detali);
                MessageBox.Show("Новая деталь добавлена!");
            }
            catch
            {
                MessageBox.Show("Что-т пошло не так, проверьте что:\n\n 1. Стоимость больше нуля\n 2. Количество деталей больше нуля");
            }
        }

        private void close_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
