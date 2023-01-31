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
    public partial class Mechanic : Form
    {
        public static Mechanic Current;
        public Mechanic()
        {
            Current = this;
            InitializeComponent();
        }

        private void close_MouseClick(object sender, MouseEventArgs e)
        {
            this.Close();
            LoginForm.Current.Close();
        }

        private void pictureBox3_Click(object sender, EventArgs e)
        {
            this.Hide();
            LoginForm.Current.Show();
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

        private void tabPage1_MouseMove(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                this.Left += e.X - lastPoint.X;
                this.Top += e.Y - lastPoint.Y;
            }
        }

        private void tabPage1_MouseDown(object sender, MouseEventArgs e)
        {
            lastPoint = new Point(e.X, e.Y);
        }

        private void Mechanic_Load_1(object sender, EventArgs e)
        {
            // TODO: This line of code loads data into the 'autoserviceDataSet.Admin_list_of_detali' table. You can move, or remove it, as needed.
            this.admin_list_of_detaliTableAdapter.Fill(this.autoserviceDataSet.Admin_list_of_detali);
            // TODO: This line of code loads data into the 'autoserviceDataSet.Mechanic_list_of_cars' table. You can move, or remove it, as needed.
            this.mechanic_list_of_carsTableAdapter.Fill(this.autoserviceDataSet.Mechanic_list_of_cars);
            string name = this.label1.Text;
            name = name.Remove(0, name.IndexOf(' ') + 1);
            try
            {
                this.архивTableAdapter.Fill(this.autoserviceDataSet.Архив, name);
                this.mechanic_list_of_ordersTableAdapter.Fill(this.autoserviceDataSet.Mechanic_list_of_orders, name);
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }
        }

        private void AddButton_Click(object sender, EventArgs e)
        {
            Mechanic_add_form mech = new Mechanic_add_form();
            mech.label1.Text = (this.label1.Text);
            //this.Close();
            DB db = new DB();

            DataTable table = new DataTable();

            SqlDataAdapter adapter = new SqlDataAdapter();

            SqlCommand command = new SqlCommand("select WINномер from ТранспортноеСредство", db.getConnection());
            adapter.SelectCommand = command;
            adapter.Fill(table);
            mech.wINномерTextBox.DataSource = table;
            mech.wINномерTextBox.DisplayMember = "WINномер";
            mech.Show();
        }

        private void mechanic_list_of_ordersDataGridView_CellContentDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            Mechanik_edit_form mech = new Mechanik_edit_form();
            mech.label1.Text = (this.label1.Text);
            string name = this.label1.Text;
            name = name.Remove(0, name.IndexOf(' ') + 1);
            mech.механикTextBox.Text = name;
            if (e.RowIndex >= 0)
            {
                DataGridViewRow row = this.mechanic_list_of_ordersDataGridView.Rows[e.RowIndex];
                mech.номерTextBox.Text = row.Cells["Номер"].Value.ToString();
                mech.wINномерTextBox.Text = row.Cells["WINномер"].Value.ToString();
                mech.СостояниеЗаказаBox1.Text = row.Cells["СостояниеЗаказа"].Value.ToString();
                //mech.стоимостьTextBox.Text = row.Cells["Стоимость"].Value.ToString();
                mech.датаОформленияDateTimePicker.Text = row.Cells["ДатаОформления"].Value.ToString();
            }
            int cost = 0;

            try
            {
                mech.list_of_detaliTableAdapter.Fill(mech.autoserviceDataSet.list_of_detali, new System.Nullable<int>(((int)(System.Convert.ChangeType(mech.номерTextBox.Text, typeof(int))))));
                mech.list_of_serviceTableAdapter.Fill(mech.autoserviceDataSet.list_of_service, new System.Nullable<int>(((int)(System.Convert.ChangeType(mech.номерTextBox.Text, typeof(int))))));
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }

            for (int i = 0; i < mech.list_of_detaliDataGridView.RowCount; i++)
            {
                cost += (Convert.ToInt32(mech.list_of_detaliDataGridView[3, i].Value)*Convert.ToInt32(mech.list_of_detaliDataGridView[4, i].Value));
            }
            for (int i = 0; i < mech.list_of_serviceDataGridView.RowCount; i++)
            {
                cost += Convert.ToInt32(mech.list_of_serviceDataGridView[1, i].Value);
            }
            mech.стоимостьTextBox.Text = Convert.ToString(cost);
            this.Close();
            mech.Show();
        }

        private void SortButton_Click(object sender, EventArgs e)
        {
            System.Windows.Forms.DataGridViewColumn Col =
                default(System.Windows.Forms.DataGridViewColumn);
            switch (listBox.SelectedIndex)
            {
                case 0:
                    Col = Номер;
                    break;
                case 1:
                    Col = WINномер;
                    break;
                case 2:
                    Col = СостояниеЗаказа;
                    break;
                case 3:
                    Col = Стоимость;
                    break;
                case 4:
                    Col = ДатаОформления;
                    break;
                case 5:
                    Col = ДатаОкончания;
                    break;
            }
            if (radioButton4.Checked)
                mechanic_list_of_ordersDataGridView.Sort(Col, System.ComponentModel.ListSortDirection.Ascending);
            else
                mechanic_list_of_ordersDataGridView.Sort(Col, System.ComponentModel.ListSortDirection.Descending);
        }

        private void FindButton_Click(object sender, EventArgs e)
        {
            mechanic_list_of_ordersBindingSource.Filter = "WINномер Like '" + FindWINField.Text + "%'";
        }

        private void ShowAllButton_Click(object sender, EventArgs e)
        {
            mechanic_list_of_ordersBindingSource.Filter = "";
        }

        private void SortButton2_Click(object sender, EventArgs e)
        {
            System.Windows.Forms.DataGridViewColumn Col =
               default(System.Windows.Forms.DataGridViewColumn);
            switch (listBox1.SelectedIndex)
            {
                case 0:
                    Col = dataGridViewTextBoxColumn2;
                    break;
                case 1:
                    Col = dataGridViewTextBoxColumn8;
                    break;
                case 2:
                    Col = dataGridViewTextBoxColumn9;
                    break;
                case 3:
                    Col = dataGridViewTextBoxColumn10;
                    break;
                case 4:
                    Col = dataGridViewTextBoxColumn11;
                    break;
                case 5:
                    Col = dataGridViewTextBoxColumn12;
                    break;
            }
            if (radioButton2.Checked)
                архивDataGridView.Sort(Col, System.ComponentModel.ListSortDirection.Ascending);
            else
                архивDataGridView.Sort(Col, System.ComponentModel.ListSortDirection.Descending);
        }

        private void FindButton2_Click(object sender, EventArgs e)
        {
            архивBindingSource.Filter = "WINномер Like '" + FindField.Text + "%'";
        }

        private void ShowAllButton2_Click(object sender, EventArgs e)
        {
            архивBindingSource.Filter = "";
        }

        private void архивDataGridView_CellContentDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            Archive_zakaz_details_form mech = new Archive_zakaz_details_form();
            if (e.RowIndex >= 0)
            {
                DataGridViewRow row = this.архивDataGridView.Rows[e.RowIndex];
                mech.NumField.Text = row.Cells["dataGridViewTextBoxColumn2"].Value.ToString();
            }

            try
            {
                mech.list_of_detaliTableAdapter.Fill(mech.autoserviceDataSet.list_of_detali, new System.Nullable<int>(((int)(System.Convert.ChangeType(mech.NumField.Text, typeof(int))))));
                mech.list_of_serviceTableAdapter.Fill(mech.autoserviceDataSet.list_of_service, new System.Nullable<int>(((int)(System.Convert.ChangeType(mech.NumField.Text, typeof(int))))));
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }
            mech.Show();
        }

        private void SortButton3_Click(object sender, EventArgs e)
        {
            System.Windows.Forms.DataGridViewColumn Col =
              default(System.Windows.Forms.DataGridViewColumn);
            switch (listBox2.SelectedIndex)
            {
                case 0:
                    Col = dataGridViewTextBoxColumn1;
                    break;
                case 1:
                    Col = dataGridViewTextBoxColumn3;
                    break;
                case 2:
                    Col = dataGridViewTextBoxColumn4;
                    break;
                case 3:
                    Col = dataGridViewTextBoxColumn5;
                    break;
                case 4:
                    Col = dataGridViewTextBoxColumn6;
                    break;
               
            }
            if (radioButton6.Checked)
                mechanic_list_of_carsDataGridView.Sort(Col, System.ComponentModel.ListSortDirection.Ascending);
            else
                mechanic_list_of_carsDataGridView.Sort(Col, System.ComponentModel.ListSortDirection.Descending);
        }

        private void FindButton3_Click(object sender, EventArgs e)
        {
            mechanic_list_of_carsBindingSource.Filter = "WINномер Like '" + FindField3.Text + "%'";
        }

        private void ShowAllButton3_Click(object sender, EventArgs e)
        {
            mechanic_list_of_carsBindingSource.Filter = "";
        }

        private void AddCarButton_Click(object sender, EventArgs e)
        {
            Mechanik_new_car_form mech = new Mechanik_new_car_form();
            string name = this.label1.Text;
            name = name.Remove(0, name.IndexOf(' ') + 1);
            mech.FIOMechField.Text = name;
            mech.Show();
        }

        private void SortButton4_Click(object sender, EventArgs e)
        {
            System.Windows.Forms.DataGridViewColumn Col =
              default(System.Windows.Forms.DataGridViewColumn);
            switch (listBox3.SelectedIndex)
            {
                case 0:
                    Col = dataGridViewTextBoxColumn13;
                    break;
                case 1:
                    Col = dataGridViewTextBoxColumn14;
                    break;
                case 2:
                    Col = dataGridViewTextBoxColumn15;
                    break;
                case 3:
                    Col = dataGridViewTextBoxColumn16;
                    break;
                case 4:
                    Col = dataGridViewTextBoxColumn18;
                    break;

            }
            if (radioButton8.Checked)
                admin_list_of_detaliDataGridView.Sort(Col, System.ComponentModel.ListSortDirection.Ascending);
            else
                admin_list_of_detaliDataGridView.Sort(Col, System.ComponentModel.ListSortDirection.Descending);
        }

        private void FindButton4_Click(object sender, EventArgs e)
        {
            admin_list_of_detaliBindingSource.Filter = "Описание Like '" + FindField3.Text + "%'";
        }

        private void ShowAllButton4_Click(object sender, EventArgs e)
        {
            admin_list_of_detaliBindingSource.Filter = "";
        }

        private void admin_list_of_detaliDataGridView_CellContentDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            Mechanic_zakaz_detali_form mech = new Mechanic_zakaz_detali_form();
            if (e.RowIndex >= 0)
            {
                DataGridViewRow row = this.admin_list_of_detaliDataGridView.Rows[e.RowIndex];
                mech.NumField.Text = row.Cells["dataGridViewTextBoxColumn7"].Value.ToString();
                mech.TypeField.Text = row.Cells["dataGridViewTextBoxColumn15"].Value.ToString();
                mech.FabField.Text = row.Cells["dataGridViewTextBoxColumn13"].Value.ToString();
                mech.SeriesField.Text = row.Cells["dataGridViewTextBoxColumn14"].Value.ToString();
                mech.FormatField.Text = row.Cells["dataGridViewTextBoxColumn17"].Value.ToString();
            }
            mech.Show();
        }

        private void AccountButton_Click(object sender, EventArgs e)
        {
            Account_form account = new Account_form();
            string name = this.label1.Text;
            name = name.Remove(0, name.IndexOf(' ') + 1);
            account.FIOField.Text = name;
            account.Show();
        }
    }
}
