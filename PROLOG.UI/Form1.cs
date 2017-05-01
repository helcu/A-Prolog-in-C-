using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using SbsSW.SwiPlCs;

namespace PROLOG.UI
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void Form1_Load(object sender, EventArgs e)
        {
            
            Environment.SetEnvironmentVariable("Path", @"D:\\swipl\\bin");
            string[] p = { "-q", "-f", @"TB1.pl" };
            Environment.SetEnvironmentVariable("SWI_HOME_DIR", @"the_PATH_to_boot32.prc");
            PlEngine.Initialize(p);
            pintarNodos(panel2);


        }

        private void button1_Click(object sender, EventArgs e)
        {



            string salida = (string)comboBox1.SelectedItem;
            PlQuery cargar = new PlQuery("cargar('TB1.bd')");
            cargar.NextSolution();

            PlQuery consulta = new PlQuery("buscarRuta(" + salida + ",'E',R)");
            foreach (PlQueryVariables i in consulta.SolutionVariables)
            {
                listBox1.Items.Add(i["R"].ToString());
            }
           
        }

        public void pintarNodos(Panel panel) {
            Graphics g = panel.CreateGraphics();
            Pen pen = new Pen(Color.Snow, 9);
            Point A = new Point(50, 60);
            Point B = new Point(177, 44);
            Point C = new Point(135, 135);
            Point D = new Point(272, 71);
            Point E = new Point(305, 156);
            Point F = new Point(448, 127);
            Point G = new Point(376, 68);
            Point H = new Point(552, 149);
            Point I = new Point(47, 255);
            Point J = new Point(217, 211);
            Point K = new Point(286, 294);
            Point L = new Point(394, 210);
            Point M = new Point(451, 302);
            Point N = new Point(522, 236);
            Point O = new Point(138, 339);


            //g.DrawRectangle(pen, 50, 60, 20, 20);

            Point[] lw1 = { A,I,K, E};

            g.DrawLines(pen, lw1);
        }

        private void panel2_MouseClick(object sender, MouseEventArgs e)
        {
           
        }
    }
}
