/**
 * @file ambb.scad
 * @brief This file contains the code for the AMBB (Additive Manufacture Breakout Board) project.
 * @author Cameron K. Brooks
 * @details The AMBB is a project that aims to create a 3D printable enclosure to demonstrate the concept
 *          of a breakout board that's 3D printable. It works by enforcing contact between an SMT (in this
 *          study, an 8-SOIC form) and header pins to create a through-hole component that's compatible with
 *          a breadboard. The AMBB is designed to be 3D printed and assembled in three parts.
 * @version 1.1
 * @copyright June 2022
 * @note This file is part of the original AMBB project as it appeared in the journal publication.
 * @note Version 1.1 was made post-publication to simply clean it up and make it more readable, no functional changes
 * were made.
 */

// Import the Spiral Extrude Library
// access to methods and functions included in the Spiral Extrude Library by Douglas Peale (Copyright 2018)
// spiral_extrude() byAKADAPis licensed under the GNU - GPL license
// obtained from thingiverse.com/thing:1958354
use<Spiral_Extrude_Library.scad>;

// number of fragments used to generate arcs
$fn = $preview ? 64 : 128;

// tolerance parameter to avoid z-fighting which can occur during the subtraction geometry with coplanar surface
// https://en.wikipedia.org/wiki/Z-fighting
zfight_tol = $preview ? 0.1 : 0;

// -------------------------------
// Enclosure parameters
// -------------------------------
enclosure_color = "DarkGreen";
enclosure_opacity = 1.0;

// base parameters
base_length = 11.00;
base_width = 13.00;
base_height = 8.25;

// slot/main cavity parameters
arc_rad = 5.5;
slot_wall_height = 3.5;
slot_width = 8;
slot_length = 9;
floor_thickness = 1.0;

// track parameters
track_width = 2;
track_height = 4;
track_depth = 0.50;
track_arc_rad = 1;

// channel parameters
chan_entry_midp_sep = 2.4;
chan_terminal_midp_sep = 1.0;
chan_group_midp_sep = 2.0;
chan_length_proj = base_width / 2 - chan_group_midp_sep + zfight_tol;
chan_entry_width = 0.7;
chan_terminal_width = 0.7;
chan_entry_height = 0.7 + zfight_tol;
chan_terminal_height = 0.7 + zfight_tol;

// channel end gap parameters
chan_terminal_end_gap_width = 0.75;
chan_terminal_eng_gap_length = chan_terminal_width + chan_terminal_midp_sep * 3;
offset1 = 0;

// BH = bolt hole
BH_rad = 2.0;
BH_height = base_height - slot_wall_height - floor_thickness;
BH_center_offset = 1.0;
BH_threading_pitch = 1.75;
BH_threading_shape_height = 1.0;
BH_threading_shape_depth = 0.50 + 0.25 * 0.5;

// chamfer dimension parameter
chamfer_dim = 3.5;

// PA = pin access
PA_front_offset = 2.0;
PA_hypot = 4.0;
PA_length = slot_length - PA_front_offset;
PA_depth = 4.5;
PA_hypot_offset = -0.5;

// -------------------------------
// Component housing parameters
// -------------------------------

// CH = component housing | PA = pin access
CH_color = "MediumOrchid";
CH_opacity = 1.0; // 0 is fully transparent and 1 is fully opaque

// component housing parameters
CH_y_offset = 14;
CH_height = 2.5;
CH_slot_width = 5.1;
CH_slot_length = 4.9;
CH_slot_depth = 1.7;
CH_slot_front_offset = 1.0;

// pin access slot parameters
CH_PA_width = 0.66;
CH_PA_height = 1.5;
CH_PA_length = 3.0;
CH_PA_sep = 0.75;

// -------------------------------
// Bolt parameters
// -------------------------------
bolt_color = "Salmon";
bolt_opacity = 1.0;

// bolt parameters
bolt_body_height = 5.0;
bolt_head_height = 2.0;
bolt_y_offset = 25;

// bolt tolerances, given as multipliers
bolt_rad_tol = 0.95;
threading_pitch_tol = 1.0;
thread_height_tol = 1.0;
thread_depth_tol = 1.0;

// derived parameters for the bolt
bolt_radius = BH_rad * bolt_rad_tol;
bolt_threading_shape_height = BH_threading_shape_height * thread_height_tol;
bolt_threading_shape_depth = BH_threading_shape_depth * thread_depth_tol;
bolt_threading_pitch = BH_threading_pitch * threading_pitch_tol;
bolt_head_width = bolt_radius * 2 + BH_threading_shape_depth * 4;

// ---------------------------------------------------------------------------------------
// Derived parameters for the enclosure - channels where the header pins will be inserted
// ---------------------------------------------------------------------------------------

// channel points for the inner channel
ChannelPointsInner =
    [[chan_terminal_midp_sep * 0.5 - chan_terminal_width / 2, chan_group_midp_sep, offset1],                        // 0
     [chan_terminal_midp_sep * 0.5 + chan_terminal_width / 2, chan_group_midp_sep, offset1],                        // 1
     [chan_entry_midp_sep * 0.5 - chan_entry_width / 2, chan_group_midp_sep + chan_length_proj, offset1],           // 2
     [chan_entry_midp_sep * 0.5 + chan_entry_width / 2, chan_group_midp_sep + chan_length_proj, offset1],           // 3
     [chan_terminal_midp_sep * 0.5 - chan_terminal_width / 2, chan_group_midp_sep, offset1 + chan_terminal_height], // 4
     [chan_terminal_midp_sep * 0.5 + chan_terminal_width / 2, chan_group_midp_sep, offset1 + chan_terminal_height], // 5
     [chan_entry_midp_sep * 0.5 - chan_entry_width / 2, chan_group_midp_sep + chan_length_proj,
      offset1 + chan_entry_height], // 6
     [chan_entry_midp_sep * 0.5 + chan_entry_width / 2, chan_group_midp_sep + chan_length_proj,
      offset1 + chan_entry_height]]; // 7

// channel points for the outer channel
ChannelPointsOuter =
    [[chan_terminal_midp_sep * 1.5 - chan_terminal_width / 2, chan_group_midp_sep, offset1],                        // 0
     [chan_terminal_midp_sep * 1.5 + chan_terminal_width / 2, chan_group_midp_sep, offset1],                        // 1
     [chan_entry_midp_sep * 1.5 - chan_entry_width / 2, chan_group_midp_sep + chan_length_proj, offset1],           // 2
     [chan_entry_midp_sep * 1.5 + chan_entry_width / 2, chan_group_midp_sep + chan_length_proj, offset1],           // 3
     [chan_terminal_midp_sep * 1.5 - chan_terminal_width / 2, chan_group_midp_sep, offset1 + chan_terminal_height], // 4
     [chan_terminal_midp_sep * 1.5 + chan_terminal_width / 2, chan_group_midp_sep, offset1 + chan_terminal_height], // 5
     [chan_entry_midp_sep * 1.5 - chan_entry_width / 2, chan_group_midp_sep + chan_length_proj,
      offset1 + chan_entry_height], // 6
     [chan_entry_midp_sep * 1.5 + chan_entry_width / 2, chan_group_midp_sep + chan_length_proj,
      offset1 + chan_entry_height]]; // 7

// channel faces
ChannelFaces = [
    [ 2, 0, 1, 3 ], // bottom
    [ 5, 1, 0, 4 ], // front
    [ 5, 4, 6, 7 ], // top
    [ 6, 4, 0, 2 ], // right
    [ 2, 3, 7, 6 ], // back
    [ 5, 7, 3, 1 ], // left
];

// -------------------------------
// Render control
// -------------------------------

render_enclosure = true;
render_component_housing = true;
render_bolt = true;

// -------------------------------
// ENCLOSURE
// -------------------------------
color(enclosure_color, enclosure_opacity) if (render_enclosure)
{

    translate([ -base_length / 2, 0, 0 ]) difference()
    {
        // main cube
        translate([ base_length / 2, 0, base_height / 2 ]) cube([ base_length, base_width, base_height ], true);

        // cube - slot
        translate([ base_length - slot_length, 0, slot_wall_height + floor_thickness ]) rotate(90, [ 0, 1, 0 ])
            linear_extrude(height = slot_length + zfight_tol) union()
        {
            difference()
            {
                translate([ sqrt(arc_rad ^ 2 - (slot_width / 2) ^ 2), 0, 0 ]) circle(arc_rad);
                translate([ -1 * 0 * sqrt(arc_rad ^ 2 - (slot_width / 2) ^ 2), -arc_rad, 0 ])
                    square([ arc_rad * 2, arc_rad * 2 ]);
            }
            translate([ -1 * 0 * sqrt(arc_rad ^ 2 - (slot_width / 2) ^ 2) + slot_wall_height / 2, 0, 0 ])
                square([ slot_wall_height, slot_width ], center = true);
        }

        // cube - slot - track
        translate([ base_length + zfight_tol / 2, 0, track_height / 2 + floor_thickness - track_depth ])
            rotate(-90, [ 0, 1, 0 ]) linear_extrude(height = base_length + zfight_tol) union()
        {
            square([ track_height, track_width ], true);
            translate([ track_height / 2, 0, 0 ]) circle(track_arc_rad);
        }

        // cube - slot - track - channels
        translate([ base_length / 2, 0, floor_thickness - chan_terminal_height + zfight_tol / 2 ]) union()
        {
            union()
            {
                polyhedron(ChannelPointsInner,
                           ChannelFaces); // channel adjacent to centerline
                polyhedron(ChannelPointsOuter,
                           ChannelFaces); // channel outside of above channel
            }
            mirror([ 0, 1, 0 ]) union()
            {
                polyhedron(ChannelPointsInner,
                           ChannelFaces); // channel adjacent to centerline
                polyhedron(ChannelPointsOuter,
                           ChannelFaces); // channel outside of above channel
            }
            mirror([ 1, 0, 0 ]) union()
            {
                polyhedron(ChannelPointsInner,
                           ChannelFaces); // channel adjacent to centerline
                polyhedron(ChannelPointsOuter,
                           ChannelFaces); // channel outside of above channel
            }
            mirror([ 0, 1, 0 ]) mirror([ 1, 0, 0 ]) union()
            {
                polyhedron(ChannelPointsInner,
                           ChannelFaces); // channel adjacent to centerline
                polyhedron(ChannelPointsOuter,
                           ChannelFaces); // channel outside of above channel
            }
        }

        // cube - slot - track - channels - bolt hole
        translate([ base_length / 2 + BH_center_offset, 0, base_height - BH_height + zfight_tol ])
            cylinder(h = BH_height, r = BH_rad);

        // cube - slot - track - channels - bolt hole - threading
        translate([ base_length / 2 + BH_center_offset, 0, base_height - BH_height + zfight_tol ])
            spiral_extrude(Radius = BH_rad - zfight_tol, EndRadius = BH_rad - zfight_tol, Pitch = BH_threading_pitch,
                           Starts = 1, Height = BH_height, StepsPerRev = 100)
        {
            square([ BH_threading_shape_depth + zfight_tol, BH_threading_shape_height ]);
        }
        // cube - slot - track - channels - bolt hole - threading - chamfer
        translate([ -zfight_tol / 2, base_width / 2 + zfight_tol, base_height - chamfer_dim ]) rotate(45, [ 1, 0, 0 ])
            cube([
                base_length + zfight_tol, (chamfer_dim / 2) / sin(45) + zfight_tol, chamfer_dim / sin(45) + zfight_tol
            ]);
        mirror([ 0, 1, 0 ]) translate([ -zfight_tol / 2, base_width / 2 + zfight_tol, base_height - chamfer_dim ])
            rotate(45, [ 1, 0, 0 ]) cube([
                base_length + zfight_tol, (chamfer_dim / 2) / sin(45) + zfight_tol, chamfer_dim / sin(45) + zfight_tol
            ]);

        // cube - slot - track - channels - bolt hole - threading - pin access
        translate([ base_length - PA_length - PA_front_offset, base_width / 2 + zfight_tol, base_height - chamfer_dim ])
            rotate(45, [ 1, 0, 0 ]) translate([ 0, -PA_depth + zfight_tol, PA_hypot_offset ])
                cube([ PA_length, PA_depth, PA_hypot ]);
        mirror([ 0, 1, 0 ]) translate(
            [ base_length - PA_length - PA_front_offset, base_width / 2 + zfight_tol, base_height - chamfer_dim ])
            rotate(45, [ 1, 0, 0 ]) translate([ 0, -PA_depth + zfight_tol, PA_hypot_offset ])
                cube([ PA_length, PA_depth, PA_hypot ]);

        translate([ base_length / 2 - chan_terminal_eng_gap_length / 2, chan_group_midp_sep, -zfight_tol / 2 ])
            cube([ chan_terminal_eng_gap_length, chan_terminal_end_gap_width, floor_thickness + zfight_tol ]);
        mirror([ 0, 1, 0 ])
            translate([ base_length / 2 - chan_terminal_eng_gap_length / 2, chan_group_midp_sep, -zfight_tol / 2 ])
                cube([ chan_terminal_eng_gap_length, chan_terminal_end_gap_width, floor_thickness + zfight_tol ]);
    }
}

// -------------------------------
// COMPONENT HOUSING
// -------------------------------
color(CH_color, CH_opacity) if (render_component_housing)
{
    difference()
    {
        translate([ 0, CH_y_offset, CH_height / 2 ]) union()
        {
            // base cube
            cube([ slot_length, slot_width - 0.1, CH_height ], true);
            // track
            translate([ 0, 0, track_depth / 2 ]) cube([ base_length, track_width, CH_height + track_depth ], true);
        }
        // IC cavity
        translate([
            slot_length / 2 - CH_slot_length / 2 - CH_slot_front_offset, CH_y_offset,
            CH_height + track_depth / 2 - CH_slot_depth / 2
        ]) cube([ CH_slot_length, CH_slot_width, CH_slot_depth + track_depth + zfight_tol ], true);

        // pin access slots
        translate([ 0, CH_y_offset, 0 ])
        {
            // Create cubes for the mirrored set
            for (i = [0:3])
            {
                for (j = [0:1])
                {
                    mirror([ 0, j, 0 ]) translate([
                        CH_PA_width * (i + 0.5) + CH_PA_sep * i - CH_slot_length + slot_length / 2 -
                            CH_slot_front_offset,
                        CH_PA_length / 2 - (slot_width - 0.1) / 2, CH_PA_height / 2
                    ])
                    {
                        cube([ CH_PA_width, CH_PA_length + zfight_tol, CH_PA_height + zfight_tol ], true);
                    }
                }
            }
        }
    }
}

// -------------------------------
// BOLT
// -------------------------------
color(bolt_color, bolt_opacity) if (render_bolt)
{
    translate([ 0, bolt_y_offset, 0 ]) difference()
    {
        union()
        {
            // head
            translate([ 0, 0, bolt_head_height / 2 ])
                cube([ bolt_head_width, bolt_head_width, bolt_head_height ], true);

            // body
            translate([ 0, 0, bolt_head_height ]) cylinder(h = bolt_body_height, r = bolt_radius);

            // threading
            translate([ 0, 0, bolt_head_height - bolt_threading_shape_height ])
                spiral_extrude(Radius = BH_rad - zfight_tol, EndRadius = bolt_radius - zfight_tol,
                               Pitch = BH_threading_pitch, Starts = 1,
                               Height = bolt_body_height + bolt_threading_shape_height, StepsPerRev = 100)
                    square([ bolt_threading_shape_depth + zfight_tol, bolt_threading_shape_height ]);
        }

        // remove hanging threading
        translate([ 0, 0, bolt_body_height + bolt_head_height + (bolt_threading_shape_height * 1.5 + zfight_tol) / 2 ])
            cube(
                [
                    bolt_radius * 2 + bolt_threading_shape_depth * 2 + zfight_tol,
                    bolt_radius * 2 + bolt_threading_shape_depth * 2 + zfight_tol, bolt_threading_shape_height * 1.5 +
                    zfight_tol
                ],
                true);
    }
}