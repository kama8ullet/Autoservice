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
    public partial class Add_detali_form : Form
    {
        public static Add_detali_form Current;
        public Add_detali_form()
        {
            
            InitializeComponent();
        }

        private void close_Click(object sender, EventArgs e)
        {
            this.Close();
        }
       
        private void AddDetaliButton_Click(object sender, EventArgs e)
        {
            try
            {
                DB db = new DB();

                db.openConnection();

                SqlCommand command = new SqlCommand();

                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandText = "Add_detali_to_zakaz";
                command.Connection = db.getConnection();

                command.Parameters.Add("@discription", SqlDbType.VarChar).Value = comboBox1.Text;
                command.Parameters.Add("@fab", SqlDbType.VarChar).Value = comboBox2.Text;
                command.Parameters.Add("@series", SqlDbType.VarChar).Value = comboBox3.Text;
                command.Parameters.Add("@count", SqlDbType.Int).Value = CountField.Text;
                command.Parameters.Add("@format", SqlDbType.VarChar).Value = FormatField.Text;
                command.Parameters.Add("@num_zakaz", SqlDbType.Int).Value = Mechanik_edit_form.Current.номерTextBox.Text;

                command.ExecuteNonQuery();
                db.closeConnection();
                try
                {
                    Mechanik_edit_form.Current.list_of_detaliTableAdapter.Fill(Mechanik_edit_form.Current.autoserviceDataSet.list_of_detali, new System.Nullable<int>(((int)(System.Convert.ChangeType(Mechanik_edit_form.Current.номерTextBox.Text, typeof(int))))));

                }
                catch (System.Exception ex)
                {
                    System.Windows.Forms.MessageBox.Show(ex.Message);
                }
                MessageBox.Show("Деталь успешно добавлена!");
            }
            catch
            {
                MessageBox.Show("Что-то пошло не так, проверьте что:\n\n 1. Нужных запчастей на складе достаточно\n 2. Возможно деталь уже есть в заказе");
            }
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            DB db = new DB();

            SqlDataAdapter adapter = new SqlDataAdapter();

            SqlCommand command1 = new SqlCommand("select Производитель from Деталь where Описание = @discription group by Производитель", db.getConnection());
            command1.Parameters.Add("@discription", SqlDbType.VarChar).Value = comboBox1.Text;
            DataTable table1 = new DataTable();
            adapter.SelectCommand = command1;
            adapter.Fill(table1);
            comboBox2.DataSource = table1;
            comboBox2.DisplayMember = "Производитель";

            SqlCommand command2 = new SqlCommand("select [Серийный номер] from Деталь where Описание = @discription and Производитель = @fab", db.getConnection());
            command2.Parameters.Add("@discription", SqlDbType.VarChar).Value = comboBox1.Text;
            command2.Parameters.Add("@fab", SqlDbType.VarChar).Value = comboBox2.Text;
            DataTable table2 = new DataTable();
            adapter.SelectCommand = command2;
            adapter.Fill(table2);
            comboBox3.DataSource = table2;
            comboBox3.DisplayMember = "Серийный номер";

            SqlCommand command3 = new SqlCommand("select ЕдИзм from Деталь where Описание = @discription and Производитель = @fab and [Серийный номер] = @series", db.getConnection());
            command3.Parameters.Add("@discription", SqlDbType.VarChar).Value = comboBox1.Text;
            command3.Parameters.Add("@fab", SqlDbType.VarChar).Value = comboBox2.Text;
            command3.Parameters.Add("@series", SqlDbType.VarChar).Value = comboBox3.Text;
            DataTable table3 = new DataTable();
            adapter.SelectCommand = command3;
            adapter.Fill(table3);
            FormatField.Text = table3.Rows[0]["ЕдИзм"].ToString();
        }

        private void comboBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
            DB db = new DB();

            SqlDataAdapter adapter = new SqlDataAdapter();

            SqlCommand command2 = new SqlCommand("select [Серийный номер] from Деталь where Описание = @discription and Производитель = @fab", db.getConnection());
            command2.Parameters.Add("@discription", SqlDbType.VarChar).Value = comboBox1.Text;
            command2.Parameters.Add("@fab", SqlDbType.VarChar).Value = comboBox2.Text;
            DataTable table2 = new DataTable();
            adapter.SelectCommand = command2;
            adapter.Fill(table2);
            comboBox3.DataSource = table2;
            comboBox3.DisplayMember = "Серийный номер";

        }
        
        Point lastPoint;
        private void label1_MouseMove(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                this.Left += e.X - lastPoint.X;
                this.Top += e.Y - lastPoint.Y;
            }
        }

        private void label1_MouseDown(object sender, MouseEventArgs e)
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
