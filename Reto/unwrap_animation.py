from manim import *




class unwrapping(ThreeDScene):
    def construct(self):
        # Make an animation that shows the unwrapping of a 3D object
        self.camera.background_color = "#E2E2E2"
        
        axes = ThreeDAxes().set_color(BLACK)

        # Sphere wrapped in z axis
        sphere1 = Surface(
            lambda u, v: np.array([
                1.5 * np.cos(u) * np.cos(v),
                1.5 * np.cos(u) * np.sin(v),
                1.5 * np.sin(u)
            ]), v_range=[0, TAU], u_range=[0, PI / 8],
            checkerboard_colors=[BLUE_D, BLUE_E], resolution=(15, 32)
        )
        sphere2 = Surface(
            lambda u, v: np.array([
                1.5 * np.cos(u) * np.cos(v),
                1.5 * np.cos(u) * np.sin(v),
                1.5 * np.sin(u)
            ]), v_range=[0, TAU], u_range=[PI / 8 , PI / 4],
            checkerboard_colors=[BLUE_D, BLUE_E], resolution=(15, 32)
        ).shift(IN/2)
        sphere3 = Surface(
            lambda u, v: np.array([
                1.5 * np.cos(u) * np.cos(v),
                1.5 * np.cos(u) * np.sin(v),
                1.5 * np.sin(u)
            ]), v_range=[0, TAU], u_range=[PI / 4 , PI / 2],
            checkerboard_colors=[BLUE_D, BLUE_E], resolution=(15, 32)
        ).shift(IN)
    


            



        self.renderer.camera.light_source.move_to(3*IN) # changes the source of the light
        self.set_camera_orientation(phi=75 * DEGREES, theta=30 * DEGREES)
        #self.add(axes, sphere1, sphere2, sphere3)
        # play create animation
        self.play(Create(axes), Create(sphere1), Create(sphere2), Create(sphere3), run_time=2)
        self.wait(2)
        # rotate camera
        self.begin_ambient_camera_rotation(rate=0.1)
        self.wait(5)
        self.play(sphere2.animate.shift(OUT/2), sphere3.animate.shift(OUT), run_time=2)
        self.wait(2)



        
