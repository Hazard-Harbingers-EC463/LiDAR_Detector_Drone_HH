import random
from itertools import count
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

plt.style.use('fivethirtyeight')

x_vals = []
y_vals = []

index = count()


def animate(i):
    data = pd.read_csv('putty_log.txt')
    fig, (ax1, ax2) = plt.subplots(2,1, squeeze=False)
    x = data['T']
    x2 = data['P']
    y1 = data['i']
    y2 = data['H']
    plt.cla()
    ax1.plot(y1[-50:-1], x[-50 :-1], label='Channel 1')
    ax2.plot(y1[-50:-1], x2[-50 :-1], label='Channel 2')

    plt.legend(loc='upper left')
    pl_ax = plt.gca()
    pl_ax.set_ylim([20, 30])
    plt.tight_layout()


ani = FuncAnimation(plt.gcf(), animate, interval=1000)

plt.tight_layout()
plt.show()