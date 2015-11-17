"Reverse correlation in neurophysiology" - Ringach, Shapley
    * Model: "subspace" reverse correlation
        - "We termed the idea of restricting the stimulus set to some smaller subset than the set of all possible random images “sub-space” reverse correlation. In the first application of the method the set of stimuli were gratings of various spatial frequencies, orientations and spatial phases (also called Hartley basis functions)"

"The Fine Structure of Shape Tuning in Area V4" - Nandy, Sharpee, Reynolds, Mitchell
    * Stimuli:
        - Monkeys fixated a central point during which each neuron’s RF was mapped using subspace reverse correlation in which Gabor (eight orientations, 80% luminance contrast, spatial frequency 1.2 cpd, Gaussian halfwidth 2deg) or ring stimuli (80% luminance contrast) appeared at 60 Hz.
        - Each stimulus appeared at a random location selected from a 19 x 15 grid with 1deg spacing in the inferior right visual field. The orientation of the Gabor stimuli and the color of all stimuli (one of six colors or achromatic) were randomly selected. This resulted in an estimate of the spatial RF, orientation, and color preference of each neuron
    * Visually selective neurons
        - The temporal window for each neuron, Tsig, was taken as those PSTH bins where the mean firing rate averaged across all stimulus conditions exceeded the baseline rate by 4 SDs
        - The baseline rate was determined from a temporal window between 0 and 20 ms after stimulus onset.
        - A neuron was considered a potential candidate for further analysis if it had a clear transient response peak that was contained within the larger 60–120 ms interval.
    * Spatially selective neurons
        - we next determined the locations within the coarse 5x5 stimulus grid where the neuron had significant spatial responses
        - We first performed a jackknife analysis on the data...then do a spatial z-score at each location comparing to baseline rate
        - The grid location was marked as significant if the spatial Z score exceeded the significance level of 0.05

    - use 15x15 grid of Gabors
    - characterize "visually selective" if 4 sds above baseline rate
    - "significant spatial responses" using z-score on jackknife test at each position

"Spectral Receptive Field Properties Explain Shape Selectivity in Area V4" - David, Hayden, Gallant
    * Model:
        - "...We recorded the responses of single V4 neurons to a large set of natural images and estimated the SRF of each neuron using linearized reverse correlation"
        - "To account for position invariance in V4 we used a nonlinear Fourier power model. According to this model the response of a neuron is a weighted sum of the spatial Fourier power of the stimulus"
    * Stimuli:
        - "Bars, Cartesian gratings, and non-Cartesian gratings were presented under manual control to determine basic receptive field properties"
        - "Receptive field size, shape, and location were confirmed by reverse correlation using a dynamic sequence of small white, black, and textured squares flashed randomly in and around the CRF" @ 10 Hz
        - "...The outer 10% of each image was blended linearly into the mean-luminance gray background."
        - NOTE: natural stimuli are shown @ 3.5-4.5 Hz
