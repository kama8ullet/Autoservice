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
    public partial class Mechanik_new_car_form : Form
    {
        public Mechanik_new_car_form()
        {
            InitializeComponent();
        }

        private void AddButton_Click(object sender, EventArgs e)
        {
            try
            {
                DB db = new DB();

                db.openConnection();
                SqlCommand command = new SqlCommand();
                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandText = "Mechanic_new_car";
                command.Connection = db.getConnection();

                command.Parameters.Add("@win", SqlDbType.VarChar).Value = WINField.Text;
                command.Parameters.Add("@fioMech", SqlDbType.VarChar).Value = FIOMechField.Text;
                command.Parameters.Add("@fioClient", SqlDbType.VarChar).Value = FIOClientField.Text;
                command.Parameters.Add("@fab", SqlDbType.VarChar).Value = FabField.Text;
                command.Parameters.Add("@model", SqlDbType.VarChar).Value = ModelField.Text;

                command.ExecuteNonQuery();
                db.closeConnection();
                Mechanic.Current.mechanic_list_of_carsTableAdapter.Fill(Mechanic.Current.autoserviceDataSet.Mechanic_list_of_cars);
                MessageBox.Show("Новое транспортное средство добавлено");
            }
            catch
            {
                MessageBox.Show("Что-то пошло не так, проверьте что:\n\n 1.Такой WIN номер прежде не был указан\n 2.Такой клиент есть в базе");
            }
        }

        private void Mechanik_new_car_form_Load(object sender, EventArgs e)
        {
            DB db = new DB();

            SqlDataAdapter adapter = new SqlDataAdapter();

            SqlCommand command1 = new SqlCommand("select ФИО from Клиент where ФИО not in (select ФИОклиента from ТранспортноеСредство)", db.getConnection());
            
            DataTable table1 = new DataTable();
            adapter.SelectCommand = command1;
            adapter.Fill(table1);
            FIOClientField.DataSource = table1;
            FIOClientField.DisplayMember = "ФИО";
        }

        private void NewClientCheck_CheckedChanged(object sender, EventArgs e)
        {
            DB db = new DB();

            SqlDataAdapter adapter = new SqlDataAdapter();

            if (NewClientCheck.Checked)
            {
                SqlCommand command1 = new SqlCommand("select ФИО from Клиент where ФИО not in (select ФИОклиента from ТранспортноеСредство)", db.getConnection());

                DataTable table1 = new DataTable();
                adapter.SelectCommand = command1;
                adapter.Fill(table1);
                FIOClientField.DataSource = table1;
                FIOClientField.DisplayMember = "ФИО";
            }
            else
            {
                SqlCommand command1 = new SqlCommand("select ФИО from Клиент where ФИО in (select ФИОклиента from ТранспортноеСредство)", db.getConnection());

                DataTable table1 = new DataTable();
                adapter.SelectCommand = command1;
                adapter.Fill(table1);
                FIOClientField.DataSource = table1;
                FIOClientField.DisplayMember = "ФИО";
            }
        }

        private void close_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
