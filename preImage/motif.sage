# -*- coding: utf-8 -*-
# -*-coding:Latin-1 -*-    





import numpy as np
import matplotlib.pyplot as plt
from matplotlib.path import Path
import matplotlib.patches as patches
from matplotlib.figure import Figure



class Motif(SageObject):
    # Constructeur
    def __init__(self, alpha = None, beta = None, tol=None):
        self.lettres = [0]       # "il faut demmarer avec une liste vide de lettres " !!
        self.elevation = 0 
        self.taille = 0
        self.alpha = alpha
        self.beta = beta
        self.tol = tol
    #
    # Méthodes
    #
    # Représenation textuelle de l'objet
    def __repr__(self):
        return repr(self.lettres)

############################ Représenation graphique##################
    def affichage(self):
        l1 = []
        l2 = []
        ord = 0
        ln=self.taille+1
        for i in range(self.taille+1):
            ord += self.lettres[i]
            #l.append((i,ord))
            l1.append(i)
            l2.append(ord) 
        fig1 = plt.figure(1,figsize=(9, 8))  
        a1 = fig1.add_subplot(111)
        
        a1.set_title('F1')
        a1.set_xlabel('X ')
        a1.set_ylabel('Y')
        a1.grid()
        a1.plot(l1,l2,'ro',color='red')
        #plt.savefig('F1');
        #plt.show()

########################## Ajout d un point 

    def Add (self, n):
        self.lettres.append(n)
        self.elevation += n
        self.taille += 1
    # Retrait du dernier point ajouté

    def Remove (self):
        n = self.lettres.pop()
        self.elevation -= n
        self.taille -= 1

####################   coder l équation     ########################

    def coder(self):  
        #rm('F1.png')
        tol=self.tol  
        xx=[]
        yy=[]  
        code=[]
        for y in range(tol):
           for x in range(tol):         
             val=self.alpha*x+self.beta -y    
             if val>=0 and val<1: 
                 xx.append(x)
                 yy.append(y)
             else : 
                 continue
        l=np.vstack((xx,yy))

        
        for i in range(1,tol):
           if (l[1,i]-l[1,i-1])==1:
                          code.append(1)
           elif (l[1,i]-l[1,i-1])==0:
                          code.append(0)  
           else:
              print("probleme dans le passage au code ! verifiez que aplha et beta sont dans l inteval [0,1]")


########## affichage  dans le cas y = alpha*x + beta #################


        x = np.linspace(0,tol+1,tol+2)
        y = self.alpha * x  + self.beta
        fig1 = plt.figure(1,figsize=(9, 8))
        a1 = fig1.add_subplot(111)
        a1.set_title('F1')
        a1.set_xlabel('X')
        a1.set_ylabel('Y')
        a1.grid()
        a1.plot(x,y,'-', xx,yy,'ro')
        a1.plot()

        plt.show()

        return code




   
      

