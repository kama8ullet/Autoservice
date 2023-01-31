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
    public partial class Mechanik_edit_form : Form
    {
        public static Mechanik_edit_form Current;
        public Mechanik_edit_form()
        {
            Current = this;
            InitializeComponent();
        }

        private void close_Click(object sender, EventArgs e)
        {
            
            Mechanic Mech = new Mechanic();
            Mech.label1.Text = (this.label1.Text);
            
            DB db = new DB();

            db.openConnection();
            SqlCommand command = new SqlCommand();

            command.CommandType = System.Data.CommandType.StoredProcedure;
            command.CommandText = "Edit_zakaz";
            command.Connection = db.getConnection();

            command.Parameters.Add("@name", SqlDbType.VarChar).Value = механикTextBox.Text;
            command.Parameters.Add("@sost", SqlDbType.VarChar).Value = СостояниеЗаказаBox1.Text;
            command.Parameters.Add("@cost", SqlDbType.Money).Value = стоимостьTextBox.Text;
            if (датаОкончанияDateTimePicker.Text == " ")
            {
                command.Parameters.Add("@date", SqlDbType.Date).Value = DBNull.Value;
            }
            else
            {
                command.Parameters.Add("@date", SqlDbType.Date).Value = датаОкончанияDateTimePicker.Text;
            }

            command.Parameters.Add("@num", SqlDbType.Int).Value = номерTextBox.Text;

            command.ExecuteNonQuery();
            db.closeConnection();

            Mech.Show();
            this.Close();
        }

        private void ConfirmEditButton_Click(object sender, EventArgs e)
        {
            try
            {
                DB db = new DB();

                db.openConnection();
                SqlCommand command = new SqlCommand();

                command.CommandType = System.Data.CommandType.StoredProcedure;
                command.CommandText = "Edit_zakaz";
                command.Connection = db.getConnection();

                command.Parameters.Add("@name", SqlDbType.VarChar).Value = механикTextBox.Text;
                command.Parameters.Add("@sost", SqlDbType.VarChar).Value = СостояниеЗаказаBox1.Text;
                command.Parameters.Add("@cost", SqlDbType.Money).Value = стоимостьTextBox.Text;
                if (датаОкончанияDateTimePicker.Text == " ")
                {
                    command.Parameters.Add("@date", SqlDbType.Date).Value = DBNull.Value;
                }
                else
                {
                    command.Parameters.Add("@date", SqlDbType.Date).Value = датаОкончанияDateTimePicker.Text;
                }

                command.Parameters.Add("@num", SqlDbType.Int).Value = номерTextBox.Text;

                command.ExecuteNonQuery();
                db.closeConnection();
                MessageBox.Show("Изминения выполнены успешно!");
            }
            catch
            {
                MessageBox.Show("Что-то пошло не так, проверьте что:\n\n 1.ФИО механика указано верно\n 2.Состояние заказа указано верно\n 3.Дата оформления и окончания указаны верно");
            }
        }

        Point lastPoint;
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

        private void label2_MouseMove(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                this.Left += e.X - lastPoint.X;
                this.Top += e.Y - lastPoint.Y;
            }
        }

        private void label2_MouseDown(object sender, MouseEventArgs e)
        {
            lastPoint = new Point(e.X, e.Y);
        }
        
        private void датаОкончанияDateTimePicker_Enter(object sender, EventArgs e)
        {
                this.датаОкончанияDateTimePicker.Format = DateTimePickerFormat.Long;
        }

        private void list_of_detaliDataGridView_MouseDoubleClick(object sender, MouseEventArgs e)
        {
            Add_detali_form add = new Add_detali_form();
            add.Show();

            DB db = new DB();

            DataTable table = new DataTable();

            SqlDataAdapter adapter = new SqlDataAdapter();

            SqlCommand command = new SqlCommand("select Описание from Деталь group by Описание", db.getConnection());
            adapter.SelectCommand = command;
            adapter.Fill(table);
            add.comboBox1.DataSource = table;
            add.comboBox1.DisplayMember = "Описание";

            SqlCommand command1 = new SqlCommand("select Производитель from Деталь where Описание = @discription group by Производитель", db.getConnection());
            command1.Parameters.Add("@discription", SqlDbType.VarChar).Value = add.comboBox1.Text;
            DataTable table1 = new DataTable();
            adapter.SelectCommand = command1;
            adapter.Fill(table1);
            add.comboBox2.DataSource = table1;
            add.comboBox2.DisplayMember = "Производитель";

            SqlCommand command2 = new SqlCommand("select [Серийный номер] from Деталь where Описание = @discription and Производитель = @fab", db.getConnection());
            command2.Parameters.Add("@discription", SqlDbType.VarChar).Value = add.comboBox1.Text;
            command2.Parameters.Add("@fab", SqlDbType.VarChar).Value = add.comboBox2.Text;
            DataTable table2 = new DataTable();
            adapter.SelectCommand = command2;
            adapter.Fill(table2);
            add.comboBox3.DataSource = table2;
            add.comboBox3.DisplayMember = "Серийный номер";

            SqlCommand command3 = new SqlCommand("select ЕдИзм from Деталь where Описание = @discription and Производитель = @fab and [Серийный номер] = @series", db.getConnection());
            command3.Parameters.Add("@discription", SqlDbType.VarChar).Value = add.comboBox1.Text;
            command3.Parameters.Add("@fab", SqlDbType.VarChar).Value = add.comboBox2.Text;
            command3.Parameters.Add("@series", SqlDbType.VarChar).Value = add.comboBox3.Text;
            DataTable table3 = new DataTable();
            adapter.SelectCommand = command3;
            adapter.Fill(table3);
            add.FormatField.Text = table3.Rows[0]["ЕдИзм"].ToString();
           
        }

        private void list_of_serviceDataGridView_MouseDoubleClick(object sender, MouseEventArgs e)
        {
            Add_service_form add = new Add_service_form();
            add.Show();
        }

        private void list_of_serviceDataGridView_RowsAdded(object sender, DataGridViewRowsAddedEventArgs e)
        {
            int cost = 0;
            for (int i = 0; i < list_of_detaliDataGridView.RowCount; i++)
            {
                cost += (Convert.ToInt32(list_of_detaliDataGridView[3, i].Value) * Convert.ToInt32(list_of_detaliDataGridView[4, i].Value));
            }
            for (int i = 0; i < list_of_serviceDataGridView.RowCount; i++)
            {
                cost += Convert.ToInt32(list_of_serviceDataGridView[1, i].Value);
            }
            стоимостьTextBox.Text = Convert.ToString(cost);
        }

        private void list_of_detaliDataGridView_RowsAdded(object sender, DataGridViewRowsAddedEventArgs e)
        {
            int cost = 0;
            for (int i = 0; i < list_of_detaliDataGridView.RowCount; i++)
            {
                cost += (Convert.ToInt32(list_of_detaliDataGridView[3, i].Value) * Convert.ToInt32(list_of_detaliDataGridView[4, i].Value));
            }
            for (int i = 0; i < list_of_serviceDataGridView.RowCount; i++)
            {
                cost += Convert.ToInt32(list_of_serviceDataGridView[1, i].Value);
            }
            стоимостьTextBox.Text = Convert.ToString(cost);
        }

        private void СостояниеЗаказаBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (СостояниеЗаказаBox1.Text == "Завершён")
            {
                this.датаОкончанияDateTimePicker.Format = DateTimePickerFormat.Long;
            }
            else if (СостояниеЗаказаBox1.Text == "В процессе")
            {
                this.датаОкончанияDateTimePicker.Format = DateTimePickerFormat.Custom;
                СостояниеЗаказаBox1.Text = "";
            }
        }
    }
    
}
