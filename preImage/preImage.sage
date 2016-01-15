# -*-coding: utf-8 -*-
# -*-coding:Latin-1 -*
import matplotlib
import matplotlib.pyplot as plt
import numpy as np
from pylab import *
from matplotlib.figure import Figure
import Tkinter as Tk



#load('motif3.sage')



class PreImage(SageObject):
    # constructeur
    def __init__(self,alpha=0, beta=0, tol=10, code='', t=4, taille=None):
        self.alpha =alpha
        self.beta =beta
        self.tol=tol+1
        self.code=code
        self.t=t
        self.motif = Motif(self.alpha, self.beta, self.tol)  #appel le constucteur motif
        self.estNonVide = True
        self.sommets = [vector([0,0]),
                        vector([1,0]), 
                        vector([1,1]),
                        vector([0,1])]

    #
    # Méthodes
    #
    # 
                        
    def __repr__(self):
        return repr(self.sommets)

#################################### "affichage polygone avec matplotlib"#############################


    def affichage (self):
        global codes

        liste=p.sommets     
        tmp=liste[0]
        liste.append(tmp)  #qui sera ignorer "closepoly"

        if len(liste)==5 :
            codes = [Path.MOVETO, Path.LINETO,Path.LINETO, Path.LINETO, Path.CLOSEPOLY]
        elif len(liste)==6:
            codes = [Path.MOVETO, Path.LINETO, Path.LINETO,Path.LINETO, Path.LINETO, Path.CLOSEPOLY]   
        elif len(liste)==4 :    
              
             codes = [Path.MOVETO,
                      Path.LINETO,
                      Path.LINETO,
                      Path.CLOSEPOLY,
                             ]
   
        else:
            liste.remove(liste[-1])
            print liste ,"\n"
            polygon(liste,xmin=0, xmax=1.01, ymin=0 , ymax=1.01, aspect_ratio= 1).show()
            print"la préImage n'est pas un polygone au sens matplotlib!...\n affichage_sage:"            
 
           
        print liste
        path = Path(liste, codes)

        fig2 = plt.figure(2,figsize=(9, 8))
        a2 = fig2.add_subplot(111)
        patch = patches.PathPatch(path, facecolor='orange', lw=2)
        a2.add_patch(patch)
        a2.plot([self.alpha],[self.beta], 'ro')
        a2.set_title('F2')        
        a2.set_xlabel('Alpha')
        a2.set_ylabel('Beta')
        a2.grid()
        a2.plot()
        fig2.canvas.mpl_connect('button_press_event', self.onclick_F2) 
        a2.set_xlim(0,1)
        a2.set_ylim(0,1)


        fig1 = plt.figure(1)
        #a1 = fig2.add_subplot(111)
        fig1.canvas.mpl_connect('button_press_event', self.onclick_F1)  

     

        plt.show() 
        ext=len(liste)-1
        print ext, liste[ext]
        liste.remove(liste[ext])
        print liste,"\n",len(liste)
        return
                        
		
    def etendMotif(self, bit):
        self.motif.Add(bit)
        self.contraindre()

####################### "transformer l équation en code et l ajouter dans le motif et afficher" #########

    def equation_to_code(self):                          # prend alpha et beta et fournie le code de fraey
         code=self.motif.coder()  
         print"le code associe a l equation:", code      #affiche la droite discréte             
         ln=len(code) 
         for i in range(ln):                             
             self.etendMotif(code[i])                    #  les droite definiees par des codes
         print("preImage non vide ?:"), self.estNonVide
                                                         # afficher la preImage
         return                                          # [self.affichage()[0]]  

########################"du code à l affichage"##############################################

    def code_to_affichage(self):
          list=[]
          list=self.code.split()          
          l=[]  
          ln=len(list)
          for i in range(ln): 
                   l.append(int(list[i]))
          print l
          tol=ln
          for i in range(tol):               #to_do (lui donner un nom car je vais l utiliser pour traiter) 
                 self.etendMotif(l[i])            #les droite definiees par des codes

          print self.motif
          self.motif.affichage() 
          self.affichage()
          
          #self.motif.coder()         
          print("preImage non vide ?:"), self.estNonVide
          return                                       #[F1,F2]
 
#########################       translation()     ###################################################

    def translation(self):
          list=[]
          t= self.t
          list=self.code.split()          
          l=[]  
          ln=len(list)
          for i in range(ln): 
                   l.append(int(list[i]))
          self=PreImage()          
          for i in range(t,ln):          
             self.etendMotif(l[i]) 
          #print self.motif     
          #self.affichage()
          self.motif.affichage()
          print("preImage non vide ?:"), self.estNonVide
          return 

############# afficher la droite euclidienne et sa discritisation####################################

    
    def contraindre(self):
        '''Ajoute un point (deux contraintes) au motif.
		Si la préImage devient vide, l'ancienne préImage 
		est restaurée mais l'attribut estNonVide vaut Faux
		'''
        k = self.motif.taille
        w_k = self.motif.elevation
        oldSommets = deepcopy(self.sommets)
        self.intersectionDemiPlan (-k, w_k, 1)
        if self.estNonVide:
		    self.intersectionDemiPlan (-k, w_k + 1, -1)
        if not self.estNonVide: 
            self.sommets = oldSommets
    
    def intersectionDemiPlan(self, a, b, auDessus):
		'''Détermine l'intersection de la préImage
		avec le demi-plan y >= ax+b (auDessus = 1)
		ou le demi-plan y < ax+b (auDessus = -1)
		puis actualise la préImage
		'''		
		aExclure = [false,false,false,false]#liste des sommets hors de la nouvelle préimage
		newSommets = []#Sommets de la nouvelle préImage
		x = self.sommets [0][0]# alias pour alléger l'écriture
		y = self.sommets [0][1]# alias pour alléger l'écriture
		if (y - (a * x + b)) * auDessus < 0:
			aExclure [0] = True
		else :
			newSommets.append(vector([x, y]))
		for i in range(1,len(self.sommets)):
			x = self.sommets [i][0]
			y = self.sommets [i][1];
			if (y - (a * x + b)) * auDessus < 0:
				aExclure [i] = True
			if aExclure [i] != aExclure [i-1]:
				# les 2 sommets ne sont pas dans le même demi-plan
				t = self.intersection (i, a, b)
 				if t != 0 and t != 1:
					newSommets.append(t*self.sommets[i-1]+(1-t)*self.sommets[i])
			if not aExclure [i]:
				newSommets.append(vector([x,y]))
		if aExclure [0] != aExclure [len(self.sommets) -1]:
			#les deux sommets ne sont pas dans le même demi-plan
			t = self.intersection (0, a, b)
			if t != 0 and t != 1:
				newSommets.append(t*self.sommets[len(self.sommets)-1]+(1-t)*self.sommets[0])
		if len(newSommets) == 0 or (len(newSommets) == 1 and auDessus == -1):
			self.estNonVide = False
		else :
			self.sommets = newSommets
			

    def  intersection (self, i, a,  b):
		''' Calcul l'intersection du segment orienté [sommets[i],
		 sommets[i-1]] avec la droite y = a x + b.
		 Return : la coordonnée barycentrique de la solution
		 PRÉ: l'intersection existe
		'''
		x1 = self.sommets[i][0]
		y1 = self.sommets[i][1]
		j = (i-1) % len(self.sommets)
		x2 = self.sommets[j][0]
		y2 = self.sommets[j][1]
		num = y1-(x1*a+b)
		den = (x2-x1)*a-(y2-y1)
 		return num / den

################## "récupérer les coordonnées de la souris dans F2" ##########################

    def onclick_F2(self,event):                               
        #print"(x, y)=",[event.xdata, event.ydata]
        alpha_tmp, beta_tmp = event.xdata, event.ydata

        fig2 = plt.figure(2)
        a2= fig2.add_subplot(111)


        fig1 = plt.figure(1)
        a1= fig1.add_subplot(111) 
        lim=self.tol
        x=np.linspace(0,lim+1,lim+2)
        y=alpha_tmp * x + beta_tmp
        a1.plot(x,y,'-')
        point=a2.plot([alpha_tmp],[beta_tmp],'o')
        canvas1.show()
        canvas2.show()
        return 

######### "récupérer les coordonnées de la souris dans F1 et afficher 2 droites ds F2" ########

    def onclick_F1(self,event):                               
        #print"(x, y)=",[event.xdata, event.ydata]
        x_tmp, y_tmp = event.xdata, event.ydata

        fig2 = plt.figure(2)
        a2= fig2.add_subplot(111) 
        lim=self.tol
        alpha=np.linspace(0,1,3)
        beta1= - x_tmp * alpha+ y_tmp +1
        beta2= - x_tmp * alpha+ y_tmp
        line_R=a2.plot(alpha,beta1,'r-')
        line_V=a2.plot(alpha,beta2,'g-')
        canvas2.show()
        return 


