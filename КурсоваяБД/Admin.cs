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
    public partial class Admin : Form
    {
        public static Admin Current;
        public Admin()
        {
            Current = this;
            InitializeComponent();
        }

        private void close_Click(object sender, EventArgs e)
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

        private void Admin_Load(object sender, EventArgs e)
        {
            // TODO: This line of code loads data into the 'autoserviceDataSet.Admin_list_of_detali' table. You can move, or remove it, as needed.
            this.admin_list_of_detaliTableAdapter.Fill(this.autoserviceDataSet.Admin_list_of_detali);
            // TODO: This line of code loads data into the 'autoserviceDataSet.Admin_list_of_service' table. You can move, or remove it, as needed.
            this.admin_list_of_serviceTableAdapter.Fill(this.autoserviceDataSet.Admin_list_of_service);
            // TODO: This line of code loads data into the 'autoserviceDataSet.Admin_list_of_workers' table. You can move, or remove it, as needed.
            this.admin_list_of_workersTableAdapter.Fill(this.autoserviceDataSet.Admin_list_of_workers);

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
                    Col = dataGridViewTextBoxColumn3;
                    break;
                case 3:
                    Col = dataGridViewTextBoxColumn4;
                    break;
                case 4:
                    Col = dataGridViewTextBoxColumn5;
                    break;
                
            }
            if (radioButton1.Checked)
                admin_list_of_workersDataGridView.Sort(Col, System.ComponentModel.ListSortDirection.Ascending);
            else
                admin_list_of_workersDataGridView.Sort(Col, System.ComponentModel.ListSortDirection.Descending);
        }

        private void FindButton_Click(object sender, EventArgs e)
        {
            admin_list_of_workersBindingSource.Filter = "ФИО Like '" + FindField.Text + "%'";
        }

        private void ShowAllButton_Click(object sender, EventArgs e)
        {
            admin_list_of_workersBindingSource.Filter = "";
        }

        private void AddSortButton_Click(object sender, EventArgs e)
        {
            Admin_add_sort_form admin = new Admin_add_sort_form();
            admin.Show();
        }

        private void AddServiceButton_Click(object sender, EventArgs e)
        {
            Admin_add_service_form admin = new Admin_add_service_form();
            admin.Show();
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

        private void FindBotton2_Click(object sender, EventArgs e)
        {
            admin_list_of_serviceBindingSource.Filter = "Название Like '" + FindField2.Text + "%'";
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
            if (radioButton6.Checked)
                admin_list_of_detaliDataGridView.Sort(Col, System.ComponentModel.ListSortDirection.Ascending);
            else
                admin_list_of_detaliDataGridView.Sort(Col, System.ComponentModel.ListSortDirection.Descending);
        }

        private void FindButton3_Click(object sender, EventArgs e)
        {
            admin_list_of_detaliBindingSource.Filter = "Описание Like '" + FindField3.Text + "%'";
        }

        private void ShowAllButton3_Click(object sender, EventArgs e)
        {
            admin_list_of_detaliBindingSource.Filter = "";
        }

        private void AddDetaliButton_Click(object sender, EventArgs e)
        {
            Admin_add_detali admin = new Admin_add_detali();
            admin.Show();
        }

        private void AccountButton_Click(object sender, EventArgs e)
        {
            Account_form account = new Account_form();
            string name = this.label1.Text;
            name = name.Remove(0, name.IndexOf(' ') + 1);
            account.FIOField.Text = name;
            account.Show();
        }

        private void admin_list_of_workersDataGridView_CellContentDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            Admin_edit_sort_form admin = new Admin_edit_sort_form();
            if (e.RowIndex >= 0)
            {
                DataGridViewRow row = this.admin_list_of_workersDataGridView.Rows[e.RowIndex];
                admin.FIOField.Text = row.Cells["dataGridViewTextBoxColumn1"].Value.ToString();
                admin.BirthField.Text = row.Cells["dataGridViewTextBoxColumn2"].Value.ToString();
                admin.StateField.Text = row.Cells["dataGridViewTextBoxColumn3"].Value.ToString();
                admin.SalaryField.Text = row.Cells["dataGridViewTextBoxColumn4"].Value.ToString();
                admin.StageField.Text = row.Cells["dataGridViewTextBoxColumn5"].Value.ToString();
                admin.TelephField.Text = row.Cells["dataGridViewTextBoxColumn6"].Value.ToString();
                admin.LoginField.Text = row.Cells["dataGridViewTextBoxColumn7"].Value.ToString();
                admin.PassField.Text = row.Cells["dataGridViewTextBoxColumn8"].Value.ToString();
            }
            admin.Show();
        }

        private void admin_list_of_serviceDataGridView_CellContentDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            Admin_edit_service_form admin = new Admin_edit_service_form();
            if (e.RowIndex >= 0)
            {
                DataGridViewRow row = this.admin_list_of_serviceDataGridView.Rows[e.RowIndex];
                admin.NameField.Text = row.Cells["dataGridViewTextBoxColumn9"].Value.ToString();
                admin.DescriptionField.Text = row.Cells["dataGridViewTextBoxColumn10"].Value.ToString();
                admin.CostField.Text = row.Cells["dataGridViewTextBoxColumn11"].Value.ToString();
                
            }
            admin.Show();
        }

        private void admin_list_of_detaliDataGridView_CellContentDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            Admin_edit_detali_form admin = new Admin_edit_detali_form();
            if (e.RowIndex >= 0)
            {
                DataGridViewRow row = this.admin_list_of_detaliDataGridView.Rows[e.RowIndex];
                admin.NumField.Text = row.Cells["Номер"].Value.ToString();
                admin.FabField.Text = row.Cells["dataGridViewTextBoxColumn13"].Value.ToString();
                admin.SeriesField.Text = row.Cells["dataGridViewTextBoxColumn14"].Value.ToString();
                admin.DescriptionField.Text = row.Cells["dataGridViewTextBoxColumn15"].Value.ToString();
                admin.CountField.Text = row.Cells["dataGridViewTextBoxColumn16"].Value.ToString();
                admin.FormatField.Text = row.Cells["dataGridViewTextBoxColumn17"].Value.ToString();
                admin.CostField.Text = row.Cells["dataGridViewTextBoxColumn18"].Value.ToString();
            }
            admin.Show();
        }
    }
}
