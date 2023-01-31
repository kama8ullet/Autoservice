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
    public partial class Add_service_form : Form
    {
        public Add_service_form()
        {
            InitializeComponent();
        }

        private void close_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void Add_service_form_Load(object sender, EventArgs e)
        {
            DB db = new DB();

            SqlDataAdapter adapter = new SqlDataAdapter();

            SqlCommand command1 = new SqlCommand("select Название from Услуга", db.getConnection());
            DataTable table1 = new DataTable();
            adapter.SelectCommand = command1;
            adapter.Fill(table1);
            comboBox1.DataSource = table1;
            comboBox1.DisplayMember = "Название";
        }

        private void AddDetaliButton_Click(object sender, EventArgs e)
        {
            try
            {
                DB db = new DB();

                db.openConnection();

                SqlCommand command = new SqlCommand();

                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandText = "Add_service_to_zakaz";
                command.Connection = db.getConnection();

                command.Parameters.Add("@num_zakaz", SqlDbType.Int).Value = Mechanik_edit_form.Current.номерTextBox.Text;
                command.Parameters.Add("@name_service", SqlDbType.VarChar).Value = comboBox1.Text;

                command.ExecuteNonQuery();
                db.closeConnection();
                try
                {
                    Mechanik_edit_form.Current.list_of_serviceTableAdapter.Fill(Mechanik_edit_form.Current.autoserviceDataSet.list_of_service, new System.Nullable<int>(((int)(System.Convert.ChangeType(Mechanik_edit_form.Current.номерTextBox.Text, typeof(int))))));
                }
                catch (System.Exception ex)
                {
                    System.Windows.Forms.MessageBox.Show(ex.Message);
                }
                MessageBox.Show("Услуга успешно добавлена!");
            }
            catch
            {
                MessageBox.Show("Такая услуга уже была оказана!");
            }
        }
        Point lastPoint;
        private void label6_MouseMove(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                this.Left += e.X - lastPoint.X;
                this.Top += e.Y - lastPoint.Y;
            }
        }

        private void label6_MouseDown(object sender, MouseEventArgs e)
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
    }
}
