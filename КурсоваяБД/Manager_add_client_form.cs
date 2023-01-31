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
    public partial class Manager_add_client_form : Form
    {
        public Manager_add_client_form()
        {
            InitializeComponent();
        }

        private void close_Click(object sender, EventArgs e)
        {
            //Manager.Current.manager_list_of_clientsTableAdapter.Fill(Manager.Current.autoserviceDataSet.Manager_list_of_clients);
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
                command.CommandText = "Add_new_client";
                command.Connection = db.getConnection();

                command.Parameters.Add("@fio", SqlDbType.VarChar).Value = FIOField.Text;
                command.Parameters.Add("@date", SqlDbType.Date).Value = BirthField.Text;
                command.Parameters.Add("@gender", SqlDbType.Char).Value = GenderField.Text;
                command.Parameters.Add("@tel", SqlDbType.BigInt).Value = TelephField.Text;


                command.ExecuteNonQuery();
                db.closeConnection();
                Manager.Current.manager_list_of_clientsTableAdapter.Fill(Manager.Current.autoserviceDataSet.Manager_list_of_clients);
                MessageBox.Show("Новый клиент добавлен");
            }
            catch
            {
                MessageBox.Show("Что-то пошло не так, проверьте что:\n\n 1.Клиент совершеннолетний\n 2.Телефон введен корретно\n 3.Однофамильцев не существует в базе");
            }
        }
        Point lastPoint;
        private void label5_MouseMove(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                this.Left += e.X - lastPoint.X;
                this.Top += e.Y - lastPoint.Y;
            }
        }

        private void label5_MouseDown(object sender, MouseEventArgs e)
        {
            lastPoint = new Point(e.X, e.Y);
        }

        private void panel2_MouseMove(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                this.Left += e.X - lastPoint.X;
                this.Top += e.Y - lastPoint.Y;
            }
        }

        private void panel2_MouseDown(object sender, MouseEventArgs e)
        {
            lastPoint = new Point(e.X, e.Y);
        }

        private void BirthField_Enter(object sender, EventArgs e)
        {
            this.BirthField.Format = DateTimePickerFormat.Long;
        }
    }
}
