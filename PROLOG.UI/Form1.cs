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

        List<Point> puntos = new List<Point>();
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
            panel2.BackgroundImage = Properties.Resources.Captura;

            puntos.Add(new Point(50, 60));
            puntos.Add(new Point(177, 44));
            puntos.Add(new Point(135, 135));
            puntos.Add(new Point(272, 71));
            puntos.Add(new Point(305, 156));
            puntos.Add(new Point(448, 127));
            puntos.Add(new Point(376, 68));
            puntos.Add(new Point(552, 149));
            puntos.Add(new Point(47, 255));
            puntos.Add(new Point(217, 211));
            puntos.Add(new Point(286, 294));

            comboBox1.SelectedIndex = 0;


        }

        private void button1_Click(object sender, EventArgs e)
        {
            listBox1.Items.Clear();
            panel2.BackgroundImage = Properties.Resources.Captura;

            panel2.Refresh();
            string salida = (string)comboBox1.SelectedItem;
            PlQuery cargar = new PlQuery("cargar('TB1.bd')");
            cargar.NextSolution();
            List<string> lista = new List<string>();
            PlQuery consulta = new PlQuery("buscarRuta('" + salida + "','E',R)");
            foreach (PlQueryVariables i in consulta.SolutionVariables)
            {
                listBox1.Items.Add(i["R"].ToString());
                lista.Add(i["R"].ToString());
            }
            listBox1.Items.RemoveAt(listBox1.Items.Count - 1);
            string li= lista[0];
            li = li.Substring(1, li.Length - 2);
            List<int> recorrido = new List<int>();
            
            foreach (String s in li.Split(','))
            {
                recorrido.Add(Int32.Parse(s.Trim()));
            }

            int distancia = recorrido[recorrido.Count - 1];

            recorrido.RemoveAt(recorrido.Count - 1);

            pintarNodos(panel2, recorrido);



        }

        public void pintarNodos(Panel panel, List<int> l) {
            Graphics g = panel.CreateGraphics();
            Pen pen = new Pen(Color.Brown, 9);

            List<Point> puntosDibujar = new List<Point>();
            foreach (var i in l)
            {
                puntosDibujar.Add(puntos[i - 1]);
            }
            Point[] s = puntosDibujar.ToArray();
            g.DrawLines(pen,s);
        }

        private void panel2_MouseClick(object sender, MouseEventArgs e)
        {
           
        }
    }
}
