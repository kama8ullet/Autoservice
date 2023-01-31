using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace КурсоваяБД
{
    public partial class Manager : Form
    {
        public static Manager Current;
        public Manager()
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

        private void tabPage1_MouseDown(object sender, MouseEventArgs e)
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

        private void Manager_Load(object sender, EventArgs e)
        {
            // TODO: This line of code loads data into the 'autoserviceDataSet.Manager_list_of_zapisi_actual' table. You can move, or remove it, as needed.
            this.manager_list_of_zapisi_actualTableAdapter.Fill(this.autoserviceDataSet.Manager_list_of_zapisi_actual);
            // TODO: This line of code loads data into the 'autoserviceDataSet.Manager_list_of_zapisi' table. You can move, or remove it, as needed.
            this.manager_list_of_zapisiTableAdapter.Fill(this.autoserviceDataSet.Manager_list_of_zapisi);
            // TODO: This line of code loads data into the 'autoserviceDataSet.Запись' table. You can move, or remove it, as needed.
            this.записьTableAdapter.Fill(this.autoserviceDataSet.Запись);
            // TODO: This line of code loads data into the 'autoserviceDataSet.Manager_list_of_clients' table. You can move, or remove it, as needed.
            this.manager_list_of_clientsTableAdapter.Fill(this.autoserviceDataSet.Manager_list_of_clients);
            // TODO: This line of code loads data into the 'autoserviceDataSet.Admin_list_of_service' table. You can move, or remove it, as needed.
            this.admin_list_of_serviceTableAdapter.Fill(this.autoserviceDataSet.Admin_list_of_service);
            // TODO: This line of code loads data into the 'autoserviceDataSet.Manager_list_of_zakaz' table. You can move, or remove it, as needed.
            this.manager_list_of_zakazTableAdapter.Fill(this.autoserviceDataSet.Manager_list_of_zakaz);

        }

        private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            ConfirmSortButton.Enabled = true;
        }

        private void ConfirmSortButton_Click(object sender, EventArgs e)
        {
            System.Windows.Forms.DataGridViewColumn Col =
                default(System.Windows.Forms.DataGridViewColumn);
            switch (listBox1.SelectedIndex)
            {
                case 0:
                    Col = dataGridViewTextBoxColumn1;
                    break;
                case 1:
                    Col = dataGridViewTextBoxColumn2;
                    break;
                case 2:
                    Col = ФИОклиента;
                    break;
                case 3:
                    Col = dataGridViewTextBoxColumn4;
                    break;
                case 4:
                    Col = dataGridViewTextBoxColumn5;
                    break;
                case 5:
                    Col = dataGridViewTextBoxColumn6;
                    break;
                case 6:
                    Col = dataGridViewTextBoxColumn7;
                    break;
            }
            if (radioButton1.Checked)
                manager_list_of_zakazDataGridView.Sort(Col, System.ComponentModel.ListSortDirection.Ascending);
            else
                manager_list_of_zakazDataGridView.Sort(Col, System.ComponentModel.ListSortDirection.Descending);
        }

        private void FindButton_Click(object sender, EventArgs e)
        {
            BindingSource bds = new BindingSource();

            List<string> filterParts = new List<string>();
            if (FindField.Text != "")
                filterParts.Add("ФИОклиента LIKE '" + FindField.Text + "%'");
            if (WINnumField.Text != "")
                filterParts.Add("WINномер LIKE '" + WINnumField.Text + "%'");
            if (MarkField.Text != "")
                filterParts.Add("Модель LIKE '" + MarkField.Text + "%'");

            string filter = string.Join(" AND ", filterParts);
            manager_list_of_zakazBindingSource.Filter = filter;
        }

        private void ShowAllButton_Click(object sender, EventArgs e)
        {
            manager_list_of_zakazBindingSource.Filter = "";
        }

        private void SortButton2_Click(object sender, EventArgs e)
        {
            System.Windows.Forms.DataGridViewColumn Col =
               default(System.Windows.Forms.DataGridViewColumn);
            switch (listBox2.SelectedIndex)
            {
                case 0:
                    Col = dataGridViewTextBoxColumn9;
                    break;
                case 1:
                    Col = dataGridViewTextBoxColumn10;
                    break;
                case 2:
                    Col = dataGridViewTextBoxColumn11;
                    break;
                
            }
            if (radioButton4.Checked)
                admin_list_of_serviceDataGridView.Sort(Col, System.ComponentModel.ListSortDirection.Ascending);
            else
                admin_list_of_serviceDataGridView.Sort(Col, System.ComponentModel.ListSortDirection.Descending);
        }

        private void FindButton2_Click(object sender, EventArgs e)
        {
            admin_list_of_serviceBindingSource.Filter = "Название Like '" + FindServiceField.Text + "%'";
        }

        private void ShowAllButton2_Click(object sender, EventArgs e)
        {
            admin_list_of_serviceBindingSource.Filter = "";
        }

        private void SortButton3_Click(object sender, EventArgs e)
        {
            System.Windows.Forms.DataGridViewColumn Col =
               default(System.Windows.Forms.DataGridViewColumn);
            switch (listBox3.SelectedIndex)
            {
                case 0:
                    Col = dataGridViewTextBoxColumn8;
                    break;
                case 1:
                    Col = dataGridViewTextBoxColumn12;
                    break;
                case 2:
                    Col = dataGridViewTextBoxColumn13;
                    break;
                case 3:
                    Col = dataGridViewTextBoxColumn14;
                    break;

            }
            if (radioButton6.Checked)
                manager_list_of_clientsDataGridView.Sort(Col, System.ComponentModel.ListSortDirection.Ascending);
            else
                manager_list_of_clientsDataGridView.Sort(Col, System.ComponentModel.ListSortDirection.Descending);
        }

        private void FindButton3_Click(object sender, EventArgs e)
        {
            manager_list_of_clientsBindingSource.Filter = "ФИО Like '" + FindFioField.Text + "%'";
        }

        private void ShowAllButton3_Click(object sender, EventArgs e)
        {
            admin_list_of_serviceBindingSource.Filter = "";
        }

        private void AddClientButton_Click(object sender, EventArgs e)
        {
            Manager_add_client_form manager = new Manager_add_client_form();
            manager.Show();
        }

        private void manager_list_of_zakazDataGridView_CellContentDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            Manager_zakaz_details_form manager = new Manager_zakaz_details_form();
            if (e.RowIndex >= 0)
            {
                DataGridViewRow row = this.manager_list_of_zakazDataGridView.Rows[e.RowIndex];
                manager.NumField.Text = row.Cells["dataGridViewTextBoxColumn1"].Value.ToString();
            }

            try
            {
                manager.list_of_detaliTableAdapter.Fill(manager.autoserviceDataSet.list_of_detali, new System.Nullable<int>(((int)(System.Convert.ChangeType(manager.NumField.Text, typeof(int))))));
                manager.list_of_serviceTableAdapter.Fill(manager.autoserviceDataSet.list_of_service, new System.Nullable<int>(((int)(System.Convert.ChangeType(manager.NumField.Text, typeof(int))))));
            }
            catch (System.Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(ex.Message);
            }
            manager.Show();
        }

        private void manager_list_of_clientsDataGridView_CellContentDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            Manager_edit_client_form manager = new Manager_edit_client_form();
            if (e.RowIndex >= 0)
            {
                DataGridViewRow row = this.manager_list_of_clientsDataGridView.Rows[e.RowIndex];
                manager.FIOField.Text = row.Cells["dataGridViewTextBoxColumn8"].Value.ToString();
                manager.DateField.Text = row.Cells["dataGridViewTextBoxColumn12"].Value.ToString();
                manager.GenderField.Text = row.Cells["dataGridViewTextBoxColumn13"].Value.ToString();
                manager.TelephField.Text = row.Cells["dataGridViewTextBoxColumn14"].Value.ToString();
            }
            manager.Show();
        }

        private void AccountButton_Click(object sender, EventArgs e)
        {
            Account_form account = new Account_form();
            string name = this.label1.Text;
            name = name.Remove(0, name.IndexOf(' ') + 1);
            account.FIOField.Text = name;
            account.Show();
        }

        private void SortButton4_Click(object sender, EventArgs e)
        {
            System.Windows.Forms.DataGridViewColumn Col =
               default(System.Windows.Forms.DataGridViewColumn);
            switch (listBox4.SelectedIndex)
            {
                case 0:
                    Col = dataGridViewTextBoxColumn15;
                    break;
                case 1:
                    Col = dataGridViewTextBoxColumn16;
                    break;
                case 2:
                    Col = dataGridViewTextBoxColumn17;
                    break;
               

            }
            if (radioButton8.Checked)
                manager_list_of_zapisiDataGridView.Sort(Col, System.ComponentModel.ListSortDirection.Ascending);
            else
                manager_list_of_zapisiDataGridView.Sort(Col, System.ComponentModel.ListSortDirection.Descending);
        }

        private void FindButton4_Click(object sender, EventArgs e)
        {
            manager_list_of_zapisiBindingSource.Filter = "ФИОклиент Like '" + FindField4.Text + "%'"; ;
        }

        private void ShowAllButton4_Click(object sender, EventArgs e)
        {
            manager_list_of_zapisiBindingSource.Filter = "";
        }

        private void AddButton4_Click(object sender, EventArgs e)
        {
            Manager_add_zapisi_form manager = new Manager_add_zapisi_form();
            manager.Show();
        }

        private void manager_list_of_zapisiDataGridView_CellContentDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            Manager_edit_or_delete_zapisi_form manager = new Manager_edit_or_delete_zapisi_form();
            if (e.RowIndex >= 0)
            {
                DataGridViewRow row = this.manager_list_of_zapisiDataGridView.Rows[e.RowIndex];
                manager.NumField.Text = row.Cells["dataGridViewTextBoxColumn15"].Value.ToString();
                manager.FioClientField.Text = row.Cells["dataGridViewTextBoxColumn16"].Value.ToString();
                manager.dateTimePicker1.Text = row.Cells["dataGridViewTextBoxColumn17"].Value.ToString();
               
            }
            manager.Show();
        }
    }
}
