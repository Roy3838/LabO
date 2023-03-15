from manim import *
import numpy as np

class Stokes(Scene):
    def construct(self):
        def getelipse(S0,S1,S2,S3):
            p=np.sqrt(S1**2 + S2 ** 2 + S3**2)/S0
            chi=np.arcsin(S3/(p*S0))/2
            phi=np.arctan(S2/S1)/2
            a=np.sqrt(S0/(np.tan(chi)**2 + 1)   )
            b=a*np.tan(chi)
            return [a,b,phi]
        
        def make_elipse(a,b,phi):
            graph = ImplicitFunction(
            lambda x, y: x**2/a.get_value()**2 + y**2/b.get_value()**2 - 1,
            color=GOLD
            ).rotate(phi.get_value()*180/PI)
            graph.add_updater(lambda m: m.become(ImplicitFunction(
                lambda x, y: x**2/a.get_value()**2 + y**2/b.get_value()**2 - 1,
                color=GOLD
            ).rotate(phi.get_value()*180/PI)
            ))
            return graph
        
        
        elipses = VGroup()

        total_elipses = 25
        for i in range(1,total_elipses):
            p = i/PI
            a = ValueTracker(0.3*np.cos(p))
            b = ValueTracker(0.3*np.sin(p))
            phi = ValueTracker(p)
            elipse = make_elipse(a,b,phi)
            elipse.shift(RIGHT*i/1.75)
            elipses.add(elipse)
        
        
        # p = ValueTracker(0)
        # [a,b,phi] = getelipse(1,1,1,1)
        # a = ValueTracker(a)
        # b = ValueTracker(b)
        # phi = ValueTracker(phi)
        # elipse = make_elipse(a,b,phi)
        elipses.center()
        self.add(elipses)
        #self.play(Create(elipses))
        #self.play(a.animate.set_value(1),b.animate.set_value(1),phi.animate.set_value(0))
        
            
            
            
        
        
        
        
        
        
        
        